import 'dart:collection';
import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CommentPagingManager<T> {
  static const _iosRotatingIndicator = SizedBox(
    width: 25.0,
    height: 25.0,
    child: const CupertinoActivityIndicator(),
  );
  // Cache extent must be smaller than card size, because when scrolling up,
  // data is loaded as soon as the first card of the page appears on the screen.
  static const double _cacheExtent = 5;
  static const _loadingIndicatorHeight = 68.0;
  final int _pageSize;

  late final AutoScrollController _autoScrollController = AutoScrollController(
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 10.0),
    axis: Axis.vertical,
  );

  AutoScrollController get autoScrollController => _autoScrollController;
  // late final _onAutoScroll;
  final PagingController<int, Comment?> _pagingController;
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
  final _customItemBuilder;

  // Check prevent manipulation of paging controller after disposal.
  bool _disposed = false;
  // Title for empty indicator.
  final String? _emptyIndicatorTitle;
  final String? _emptyIndicatorSubtitle;

  int _lastIncompletePageSize = 0;
  int _pageKeyToResume = 0;

  /// Jump floor related.
  int _initialIndex;
  JumpFloorValues jumpFloorValues;

  CommentPagingManager(
      this._pageSize, this._customFetchApi, this._customItemBuilder,
      {emptyIndicatorTitle, emptyIndicatorSubtitle, initialIndex: 0})
      : this._emptyIndicatorTitle = emptyIndicatorTitle,
        this._emptyIndicatorSubtitle = emptyIndicatorSubtitle,
        this._initialIndex = initialIndex,
        jumpFloorValues =
            JumpFloorValues(initialIndex ~/ _pageSize * _pageSize),
        this._pagingController = PagingController(
          firstPageKey: initialIndex ~/ _pageSize * _pageSize,
        ) {
    /// Wrap [_customFetchApi] with pageKey, because _fetchPage uses page number
    /// as parameter.
    this._wrappedFetchApi = (pageKey) {
      _fetchPage(pageKey);
    };

    /// Add bottom fetch listener (by index).
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

  // TODO: If fetching for the first time, fetch two pages so that the whole
  // page can be filled with cards, which prevents
  Future<void> _fetchPage(int pageKey) async {
    // print('fetching page ${pageKey ~/ _pageSize}');
    try {
      final newItems = await _customFetchApi(pageKey ~/ _pageSize, _pageSize);

      if (this._disposed) {}

      final isCurrentlyLastPage = newItems.length < _pageSize;

      int newlyAddedItemCount = newItems.length - _lastIncompletePageSize;

      final List<Comment> truncatedNewItems = (newItems as List<Comment>)
          .sublist(newItems.length - newlyAddedItemCount);

      // Mark new data as rebuild because of bottom refresh new
      // data, so the buildAsCard property remains false.
      if (jumpFloorValues._hasBottomRefreshed == true) {
        for (int i = jumpFloorValues._recentlyFetchedTopIndex;
            i < jumpFloorValues._recentlyFetchedTopIndex + _pageSize;
            ++i) {
          if (!jumpFloorValues._hasBuiltAsCard.contains(i)) {
            jumpFloorValues._rebuildBecauseOfNewData.add(i);
          }
        }
        jumpFloorValues._hasBottomRefreshed = false;
      }

      if (isCurrentlyLastPage) {
        _lastIncompletePageSize = newItems.length;

        _pagingController.appendLastPage(truncatedNewItems);
        _pageKeyToResume = pageKey;
      } else {
        _lastIncompletePageSize = 0;
        final nextPageKey = pageKey + truncatedNewItems.length;
        _pagingController.appendPage(truncatedNewItems, nextPageKey);
      }

      if (jumpFloorValues._firstTimeFetch) {
        jumpFloorValues._firstTimeFetch = false;

        /// Jump floor and add top listener only when initial floor is not 0.
        if (_initialIndex != 0) {
          Future.delayed(Duration(milliseconds: 400), () async {
            await scrollToIndex(_initialIndex);

            if (_autoScrollController.position.pixels < _cacheExtent + 0.1) {
              // print('trigger scroll position adjustment');
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _autoScrollController.jumpTo(_cacheExtent + 0.1);
              });
            }

            jumpFloorValues._firstJumpCompleted = true;
          });
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  refresh({jumpTo: 0}) {
    // print('==== refresh ====');
    _pagingController.removePageRequestListener(this._wrappedFetchApi);
    // print('listener removed');

    _initialIndex = jumpTo;
    int indexOfFirstElementInPageToBeFetched =
        _initialIndex ~/ _pageSize * _pageSize;
    _lastIncompletePageSize = 0;
    _pageKeyToResume = 0;
    jumpFloorValues = JumpFloorValues(indexOfFirstElementInPageToBeFetched);

    _pagingController.refresh();

    _pagingController.addPageRequestListener(this._wrappedFetchApi);
    _pagingController.notifyPageRequestListeners(jumpTo);
    // print('refreshed');
  }

  dispose() {
    if (_disposed == false) {
      _disposed = true;
      _pagingController.dispose();
      _autoScrollController.dispose();
    }
  }

  /// Refreshable means can user refresh by swiping down the screen.
  /// Refreshing programmatically is always doable.
  Widget getListView({refreshable = true}) {
    /// Fill item list with dummy objects.
    ///
    /// Tricky: if [_initialIndex] is smaller than page size but not zero,
    /// [_pagingController.itemList] should be null,
    /// otherwise an empty indicator will be displayed.
    if (_initialIndex != 0 && jumpFloorValues._recentlyFetchedTopIndex != 0) {
      _pagingController.itemList = List<Comment?>.filled(
          jumpFloorValues._recentlyFetchedTopIndex, null,
          growable: true);
    }
    // print(_pagingController.itemList);

    PagedListView<int, Comment?> listView = PagedListView<int, Comment?>(
      scrollController: _autoScrollController,
      pagingController: _pagingController,
      cacheExtent: _cacheExtent,
      builderDelegate: PagedChildBuilderDelegate<Comment>(
        animateTransitions: false,
        itemBuilder: (context, Comment? item, index) {
          if (item != null) {
            jumpFloorValues._recentlyBuiltTopIndex =
                min(index, jumpFloorValues._recentlyBuiltTopIndex);
          }

          print('item builder called on index $index');

          return AutoScrollTag(
            key: ValueKey(index),
            controller: _autoScrollController,
            index: index,
            child: buildListItem(context, item, index),
          );
        },
        firstPageProgressIndicatorBuilder: (_) => Container(),
        noItemsFoundIndicatorBuilder: (_) => buildEmptyWidget(),
        noMoreItemsIndicatorBuilder: (_) => buildNoMoreItemsIndicator(),
      ),
    );

    Widget wrappedListView = this._initialIndex != 0
        ? NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                if (!jumpFloorValues._hasFirstScrolled) {
                  // print('first time scroll');
                  jumpFloorValues._hasFirstScrolled = true;
                  return false;
                }

                // print('about to load new page');

                () async {
                  int _fetchTopIndex = jumpFloorValues._recentlyFetchedTopIndex;
                  print(_fetchTopIndex);
                  print(jumpFloorValues._recentlyBuiltTopIndex);

                  if (_fetchTopIndex ==
                          jumpFloorValues._recentlyBuiltTopIndex &&
                      jumpFloorValues._isLoadingTop == false &&
                      _fetchTopIndex != 0 &&
                      _autoScrollController.position.pixels <
                          _loadingIndicatorHeight) {
                    jumpFloorValues._isLoadingTop = true;

                    print('scroll to top!');
                    print(
                        'fetching page ${_fetchTopIndex ~/ _pageSize - 1} due to scroll to top');

                    // Get new items and stuff them in paging controller's item list.
                    List<Comment> newItems = await _customFetchApi(
                        _fetchTopIndex ~/ _pageSize - 1, _pageSize);
                    List<Comment?>? currentItems = _pagingController.itemList;
                    currentItems!.replaceRange(
                        _fetchTopIndex - _pageSize, _fetchTopIndex, newItems);
                    _pagingController.itemList = currentItems;

                    // Decrement recently fetched top index and set loading
                    // status.
                    jumpFloorValues._recentlyFetchedTopIndex -= _pageSize;
                    jumpFloorValues._isLoadingTop = false;

                    if (!_disposed) {
                      _autoScrollController.animateTo(
                          _loadingIndicatorHeight + 0.1 + _cacheExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut);
                    }
                  }
                }();
              }
              return false;
            },
            child: listView)
        : listView;

    return refreshable
        ? AdaptiveRefresher(
            onRefresh: () {
              _pagingController.refresh();
              return Future.delayed(Duration.zero);
            },
            iosComplete: _iosRotatingIndicator,
            child: wrappedListView,
          )
        : wrappedListView;
  }

  /// Do not support highlight here.
  /// Need to do highlight job outside PagingManager.
  Future scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
  }

  buildEmptyWidget() => Container(
      height: 1,
      padding: EdgeInsets.fromLTRB(60, 0, 60, 80),
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
      ));

  buildNoMoreItemsIndicator() => GestureDetector(
        onTap: () => _loadBottomItems(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('-  暂时没有更多内容，点击刷新  -',
                  style: TextStyle(color: Colors.grey)))
        ]),
      );

  Widget buildListItem(context, item, index) {
    if (item == null) {
      if (index == jumpFloorValues._recentlyFetchedTopIndex - 1 &&
          jumpFloorValues._firstJumpCompleted == true) {
        print('$index build as indicator');
        return Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        // print('shrink box');
        return SizedBox.shrink();
      }
    }
    // Build item as Card.
    else {
      bool shouldHighlight = handleHighlight(index);

      if (jumpFloorValues._rebuildBecauseOfNewData.contains(index)) {
        jumpFloorValues._rebuildBecauseOfNewData.remove(index);
        return SizedBox.shrink();
      }
      // Data is present but the card never scrolls into viewport, should build
      // it as a dummy.
      if (jumpFloorValues._shouldBuildAsShrink != null &&
          jumpFloorValues._shouldBuildAsShrink![index] == true) {
        print('should build as shrink');
        jumpFloorValues._shouldBuildAsShrink![index] = false;
        return SizedBox.shrink();
      }

      print('$index build as card!');
      jumpFloorValues._hasBuiltAsCard.add(index);

      Widget _widget = _customItemBuilder(context, item, index,
          highlight: index == _initialIndex && shouldHighlight);
      return _widget;
    }
  }

  bool handleHighlight(index) {
    bool _shouldHighlight =
        !jumpFloorValues._hasHighlighted && index == _initialIndex;

    if (_shouldHighlight) {
      Future.delayed(Duration(milliseconds: Constants.defaultHighlightTime),
          () => jumpFloorValues._hasHighlighted = true);
    }

    return _shouldHighlight;
  }

  _loadBottomItems() {
    jumpFloorValues._shouldBuildAsShrink = new HashMap();

    List<Comment?>? _itemList = _pagingController.itemList;

    print(_itemList);
    _itemList!.asMap().forEach((key, value) {
      if (value != null && !jumpFloorValues._hasBuiltAsCard.contains(key)) {
        print('$key should not be drawed on next rebuild');
        jumpFloorValues._shouldBuildAsShrink![key] = true;
      }
    });

    jumpFloorValues._hasBottomRefreshed = true;
    _pagingController.nextPageKey = _pageKeyToResume;
  }
}

class JumpFloorValues {
  bool _isLoadingTop = false;
  bool _firstTimeFetch = true;
  bool _firstJumpCompleted = false;
  bool _hasFirstScrolled = false;
  bool _hasHighlighted = false;
  bool _hasBottomRefreshed = false;
  int _recentlyFetchedTopIndex;
  int _recentlyBuiltTopIndex;
  Set<int> _hasBuiltAsCard;
  Set<int> _rebuildBecauseOfNewData;
  Map<int, bool>? _shouldBuildAsShrink;

  JumpFloorValues(topIndex)
      : _recentlyFetchedTopIndex = topIndex,
        _recentlyBuiltTopIndex = topIndex,
        _hasBuiltAsCard = HashSet(),
        _rebuildBecauseOfNewData = HashSet();
}
