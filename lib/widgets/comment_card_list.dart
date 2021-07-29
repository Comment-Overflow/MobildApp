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
  final int _pageIndex;
  final int _userId;

  CommentCardList(this._post, this._userId, {Key? key, pageIndex: 0})
      : _pageIndex = pageIndex,
        super(key: key);

  @override
  _CommentCardListState createState() =>
      _CommentCardListState(_post, _pageIndex, _userId);
}

class _CommentCardListState extends State<CommentCardList> {
  late CommentPagingManager<Comment> _pagingManager;
  int _pageIndex;
  bool _dirty = false;

  _CommentCardListState(Post post, int pageIndex, int userId)
      : _pageIndex = pageIndex;

  @override
  initState() {
    Post post = widget._post;
    int userId = widget._userId;

    _pagingManager = CommentPagingManager(
      Constants.defaultPageSize,
      (page, pageSize) async {
        var response = await PostService.getPostComments(CommentQueryDTO(
            postId: widget._post.postId,
            policy: SortPolicy.earliest,
            pageNum: page,
            pageSize: pageSize));
        var commentObjJson = response.data['content'] as List;
        return commentObjJson.map((e) => Comment.fromJson(e)).toList();
      },
      (context, item, index, {highlight: false}) => (item as Comment).floor == 0
          ? CommentCard(item, post.postId, userId, title: post.title)
          : CommentCard(
              item,
              post.postId,
              userId,
              highlight: highlight,
              replyCallback: _replyCallback,
            ),
      initialIndex: _pageIndex,
    );

    super.initState();
  }

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
    if (_dirty) {
      _pagingManager.refresh(jumpTo: _pageIndex);
    } else {
      _dirty = true;
    }

    return _pagingManager.getListView(refreshable: false);
  }

  _replyCallback(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }
}
