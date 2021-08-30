import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PagingManager<T> {
  static const _iosRotatingIndicator = SizedBox(
    width: 25.0,
    height: 25.0,
    child: const CupertinoActivityIndicator(),
  );
  final int _pageSize;
  late final AutoScrollController _autoScrollController = AutoScrollController(
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 10.0),
    axis: Axis.vertical,
  );
  AutoScrollController get autoScrollController => _autoScrollController;
  // late final _onAutoScroll;
  final PagingController<int, T> _pagingController =
      PagingController(firstPageKey: 0);

  // _customApi must be wrapped with a function with parameters
  // (pageKey, pageSize), such as
  //
  // ```dart
  // (page, pageSize) => {
  //   getBooks(bookId: 0, page, pageSize);
  // }
  // ```
  var _customFetchApi;
  var _wrappedFetchApi;

  // _customItemBuilder should be a function with parameters
  // (context, item, index), and must return a widget displayed as list item
  // such as
  final Widget Function(BuildContext, dynamic, int) _customItemBuilder;

  // Check prevent manipulation of paging controller after disposal.
  bool _disposed = false;
  // Title for empty indicator.
  String? _emptyIndicatorTitle;
  String? _emptyIndicatorSubtitle;

  Widget _firstPageIndicator;

  PagingManager(this._pageSize, this._customFetchApi, this._customItemBuilder,
      {enableAutoScroll = false,
      emptyIndicatorTitle,
      emptyIndicatorSubtitle,
      firstPageIndicator})
      : _emptyIndicatorTitle = emptyIndicatorTitle,
        _emptyIndicatorSubtitle = emptyIndicatorSubtitle,
        _firstPageIndicator =
            firstPageIndicator == null ? Container() : firstPageIndicator {
    this._wrappedFetchApi = (pageKey) {
      _fetchPage(pageKey);
    };

    _pagingController.addPageRequestListener(this._wrappedFetchApi);
  }

  changeCustomFetchApi(newApi) {
    _pagingController.removePageRequestListener(this._wrappedFetchApi);
    this._customFetchApi = newApi;
    this._wrappedFetchApi = (pageKey) {
      _fetchPage(pageKey);
    };
    _pagingController.addPageRequestListener(this._wrappedFetchApi);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _customFetchApi(pageKey ~/ _pageSize, _pageSize);
      if (this._disposed) {
        return;
      }
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length as int;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  refresh() {
    _pagingController.refresh();
  }

  dispose() {
    if (_disposed == false) {
      _disposed = true;
      _pagingController.dispose();
    }
  }

  /// Refreshable means can user refresh by swiping down the screen.
  /// Refreshing programmatically is always doable.
  Widget getListView({refreshable = true}) {
    PagedListView<int, T> listView = PagedListView<int, T>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        animateTransitions: true,
        transitionDuration: const Duration(milliseconds: 200),
        itemBuilder: (context, item, index) =>
            _customItemBuilder(context, item, index),
        firstPageProgressIndicatorBuilder: (_) => _firstPageIndicator,
        noItemsFoundIndicatorBuilder: (_) => buildEmptyWidget(),
        noMoreItemsIndicatorBuilder: (_) => buildNoMoreItemsIndicator(),
      ),
    );

    return refreshable
        ? AdaptiveRefresher(
            onRefresh: () {
              _pagingController.refresh();
              return Future.delayed(Duration.zero);
            },
            iosComplete: _iosRotatingIndicator,
            child: listView,
          )
        : listView;
  }

  /// Do not support highlight here.
  /// Need to do highlight job outside PagingManager.
  Future scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
  }

  buildEmptyWidget() => Container(
      height: 1,
      padding: EdgeInsets.fromLTRB(60, 0, 60, 60),
      child: EmptyWidget(
        image: null,
        packageImage: PackageImage.Image_1,
        title: _emptyIndicatorTitle,
        subTitle: _emptyIndicatorSubtitle,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: Color(0xffabb8d6),
        ),
        hideBackgroundAnimation: true,
      ));

  buildNoMoreItemsIndicator() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('-  暂时没有更多内容  -', style: TextStyle(color: Colors.grey)))
      ]);
}
