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
  final Function _replyCallback;
  final Function _setMaxCallback;
  final Function _changePageCallback;
  final Function _distantJumpCallback;

  CommentCardList(this._post, this._userId, this._replyCallback,
      this._setMaxCallback, this._distantJumpCallback, this._changePageCallback,
      {Key? key, pageIndex: 0})
      : _pageIndex = pageIndex,
        super(key: key);

  @override
  _CommentCardListState createState() =>
      _CommentCardListState(_post, _pageIndex, _userId);
}

class _CommentCardListState extends State<CommentCardList> {
  late CommentPagingManager<Comment> _pagingManager;
  int _pageIndex;

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
        widget._setMaxCallback((response.data['size'] as int) ~/ pageSize);
        return commentObjJson.map((e) => Comment.fromJson(e)).toList();
      },
      (context, item, index, {highlight: false, jumpCallback}) =>
          (item as Comment).floor == 0
              ? CommentCard(
                  item,
                  post.postId,
                  userId,
                  title: post.title,
                  isPostFrozen: post.isFrozen,
                )
              : CommentCard(
                  item,
                  post.postId,
                  userId,
                  highlight: highlight,
                  replyCallback: widget._replyCallback,
                  jumpCallback: jumpCallback,
                  isPostFrozen: post.isFrozen,
                ),
      widget._distantJumpCallback,
      widget._changePageCallback,
      initialIndex: _pageIndex,
      firstPageIndicator: SkeletonCommentCardList(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView(refreshable: false);
  }
}
