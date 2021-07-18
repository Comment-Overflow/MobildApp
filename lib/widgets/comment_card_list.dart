import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:flutter/cupertino.dart';

import 'comment_card.dart';

class CommentCardList extends StatefulWidget {
  /// Can't be accessed in initializer, try to find new way.
  final Post _post;
  // Sorting policy
  final SortPolicy _sortPolicy;

  CommentCardList(this._post, this._sortPolicy, {Key? key}) : super(key: key);

  @override
  _CommentCardListState createState() =>
      _CommentCardListState(this._post.title, this._sortPolicy);
}

class _CommentCardListState extends State<CommentCardList> {
  PagingManager<Comment> _pagingManager;

  _CommentCardListState(title, sortPolicy)
      : _pagingManager = PagingManager(Constants.defaultPageSize,
            (page, pageSize) {
          print('fetch $page with original policy');
          return Future.delayed(
            const Duration(milliseconds: 300),
            () => comments.sublist(
                page * pageSize, min((page + 1) * pageSize, comments.length)),
          );
        },
            (context, item, index) => index == 0
                ? CommentCard(item, title: title)
                : CommentCard(item));

  @override
  void didUpdateWidget(CommentCardList oldWidget) {
    _pagingManager.changeCustomFetchApi((page, pageSize) {
      print('fetch $page with changed policy');
      return Future.delayed(
        const Duration(milliseconds: 300),
        () => comments.sublist(
            page * pageSize, min((page + 1) * pageSize, comments.length)),
      );
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pagingManager.refresh();
    return _pagingManager.getListView();
  }
}
