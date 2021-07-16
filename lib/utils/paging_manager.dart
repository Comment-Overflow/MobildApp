import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PagingManager<T> {
  final _pageSize;
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
  final _customFetchApi;
  // _customItemBuilder should be a function with parameters
  // (context, item, index), and must return a widget displayed as list item
  // such as
  final _customItemBuilder;
  // Check prevent manipulation of paging controller after disposal.
  bool _disposed = false;

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

  PagingManager(this._pageSize, this._customFetchApi, this._customItemBuilder) {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  dispose() {
    _disposed = true;
    _pagingController.dispose();
  }

  Widget getListView({refreshable = true}) {
    PagedListView<int, T> listView = PagedListView<int, T>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        animateTransitions: true,
        transitionDuration: const Duration(milliseconds: 200),
        itemBuilder: _customItemBuilder,
        firstPageProgressIndicatorBuilder: (_) => Container(),
      ),
    );

    return refreshable
        ? AdaptiveRefresher(
            onRefresh: () {
              _pagingController.refresh();
            },
            iosComplete: buildIosRotatingIndicator(),
            child: listView,
          )
        : listView;
  }

  buildIosRotatingIndicator() => SizedBox(
        width: 25.0,
        height: 25.0,
        child: const CupertinoActivityIndicator(),
      );

  // buildMaterialRotatingIndicator() =>
}
