import 'dart:convert';
import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/comments_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:flutter/cupertino.dart';

import 'comment_card.dart';

class CommentCardList extends StatefulWidget {

  final Post _post;
  final SortPolicy _sortPolicy;

  CommentCardList(this._post, this._sortPolicy, {Key? key}) : super(key: key);

  @override
  _CommentCardListState createState() =>
      _CommentCardListState(this._post, this._sortPolicy);
}

class _CommentCardListState extends State<CommentCardList> {
  PagingManager<Comment> _pagingManager;

  _CommentCardListState(Post post, SortPolicy sortPolicy)
      : _pagingManager = PagingManager(Constants.defaultPageSize,
            (page, pageSize) async {
          var response = await PostService.getPostComments(
            CommentQueryDTO(
              postId: post.postId,
              policy: sortPolicy,
              pageNum: page,
              pageSize: pageSize)
          );
          var commentObjJson = response.data['content'] as List;
          return commentObjJson.map((e) => Comment.fromJson(e)).toList();
        },
            (context, item, index) => index == 0
                ? CommentCard(item, title: post.title)
                : CommentCard(item));

  @override
  void didUpdateWidget(CommentCardList oldWidget) {
    _pagingManager.changeCustomFetchApi((page, pageSize) {
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
