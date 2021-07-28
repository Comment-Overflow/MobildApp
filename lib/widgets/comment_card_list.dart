import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/comments_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'comment_card.dart';
import 'comment_paging_manager.dart';

class CommentCardList extends StatefulWidget {
  final Post _post;
  final int _pageIndex = 24;

  CommentCardList(this._post, {Key? key}) : super(key: key);

  @override
  _CommentCardListState createState() =>
      _CommentCardListState(_post, _pageIndex);
}

class _CommentCardListState extends State<CommentCardList> {
  CommentPagingManager<Comment> _pagingManager;
  bool dirty = false;

  _CommentCardListState(Post post, int pageIndex)
      : _pagingManager = CommentPagingManager(
          Constants.defaultPageSize,
          (page, pageSize) async {
            var response = await PostService.getPostComments(CommentQueryDTO(
                postId: post.postId,
                policy: SortPolicy.earliest,
                pageNum: page,
                pageSize: pageSize));
            var commentObjJson = response.data['content'] as List;
            return commentObjJson.map((e) => Comment.fromJson(e)).toList();
          },
          (context, item, index) => (item as Comment).floor == 0
              ? CommentCard(item, post.postId, title: post.title)
              : CommentCard(item, post.postId),
          initialIndex: pageIndex,
        );

  @override
  void didUpdateWidget(CommentCardList oldWidget) {
    _pagingManager.changeCustomFetchApi((page, pageSize) async {
      var response = await PostService.getPostComments(CommentQueryDTO(
          postId: widget._post.postId,
          policy: SortPolicy.earliest,
          pageNum: page,
          pageSize: pageSize));
      var commentObjJson = response.data['content'] as List;
      return commentObjJson.map((e) => Comment.fromJson(e)).toList();
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
    _pagingManager.refresh(jumpTo: widget._pageIndex);
    return _pagingManager.getListView(refreshable: false);
  }
}
