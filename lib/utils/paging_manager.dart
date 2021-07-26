import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PagingManager<T> {
  static const _iosRotatingIndicator = SizedBox(
    width: 25.0,
    height: 25.0,
    child: const CupertinoActivityIndicator(),
  );
  final _pageSize;
  late final AutoScrollController _autoScrollController = AutoScrollController(
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 10.0),
    axis: Axis.vertical,
  );

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
  // Should the list be able to auto scroll.
  bool _enableAutoScroll;

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

  PagingManager(this._pageSize, this._customFetchApi, this._customItemBuilder,
      {enableAutoScroll = false})
      : this._enableAutoScroll = enableAutoScroll {
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

  refresh() {
    _pagingController.refresh();
  }

  dispose() {
    if (_disposed == false) {
      _disposed = true;
      _pagingController.dispose();
      _autoScrollController.dispose();
    }
  }

  Widget getListView({refreshable = true}) {
    PagedListView<int, T> listView = PagedListView<int, T>(
      scrollController: _enableAutoScroll ? _autoScrollController : null,
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        animateTransitions: true,
        transitionDuration: const Duration(milliseconds: 200),
        itemBuilder: (context, item, index) => AutoScrollTag(
          key: ValueKey(index),
          controller: _autoScrollController,
          index: index,
          child: _customItemBuilder(context, item, index),
        ),
        firstPageProgressIndicatorBuilder: (_) => Container(),
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
}
