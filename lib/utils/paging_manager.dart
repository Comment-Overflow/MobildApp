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

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _customFetchApi(pageKey ~/ _pageSize, _pageSize);
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
    _pagingController.dispose();
  }

  RefreshIndicator getListView() =>
    RefreshIndicator(
      child: PagedListView<int, T>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          itemBuilder: _customItemBuilder,
        ),
      ),
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
    );
}