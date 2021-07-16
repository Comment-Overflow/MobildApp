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

  final PagingManager<Comment> _pagingManager;

  CommentCardList(this._post, {Key? key})
      : _pagingManager = PagingManager(Constants.defaultPageSize,
            (page, pageSize) {
          return Future.delayed(
            const Duration(seconds: 1),
            () => comments.sublist(
                page * pageSize, min((page + 1) * pageSize, comments.length)),
          );
        },
            (context, item, index) => index == 0
                ? CommentCard(item, title: _post.title)
                : CommentCard(item)),
        super(key: key);

  @override
  _CommentCardListState createState() => _CommentCardListState();
}

class _CommentCardListState extends State<CommentCardList> {
  @override
  void dispose() {
    super.dispose();
    widget._pagingManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget._pagingManager.getListView();
  }
}
