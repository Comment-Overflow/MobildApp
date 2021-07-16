import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:flutter/cupertino.dart';

import 'comment_card.dart';

class CommentCardList extends StatefulWidget {
  /// Can't be accessed in initializer, try to find new way.
  final List<Comment> _commentList;

  const CommentCardList(this._commentList, {Key? key}) : super(key: key);

  @override
  _CommentCardListState createState() => _CommentCardListState();
}

class _CommentCardListState extends State<CommentCardList> {
  final PagingManager<Comment> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => comments.sublist(
          page * pageSize, min((page + 1) * pageSize, comments.length)),
    );
  }, (context, item, index) => CommentCard(item));

  @override
  void dispose() {
    super.dispose();
    _pagingManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView();
  }
}
