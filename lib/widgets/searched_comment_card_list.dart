import 'dart:core';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/service/search_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_post_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class SearchedCommentCardList extends StatefulWidget {
  final String _searchKey;
  final PostTag? _postTag;
  final int? _userId;

  const SearchedCommentCardList(this._searchKey, {Key? key, postTag, userId})
      : _postTag = postTag,
        _userId = userId,
        super(key: key);

  @override
  _SearchedCommentCardListState createState() =>
      _SearchedCommentCardListState(_searchKey, _postTag, _userId);
}

class _SearchedCommentCardListState extends State<SearchedCommentCardList> {
  final PagingManager<SearchedPost> _pagingManager;

  _SearchedCommentCardListState(searchKey, postTag, userId)
      : _pagingManager = PagingManager(
          Constants.defaultPageSize,
          (page, pageSize) async {
            final Response response = userId == null
                ? (await SearchService.searchComment(searchKey, page, pageSize,
                    postTag: postTag))
                : (await PostService.getMyComments(userId.toString(),
                    PostQueryDTO(pageNum: page, pageSize: pageSize)));
            // The type is Post, but they are actually comments.
            List searchedComments = (response.data as List)
                .map((i) => SearchedPost.fromJson(i))
                .toList();
            return searchedComments;
          },
          (context, item, index) => SearchedCommentCard(item, [searchKey]),
          emptyIndicatorTitle: Constants.searchCommentEmptyIndicatorTitle,
          emptyIndicatorSubtitle: Constants.searchCommentEmptyIndicatorSubtitle,
          firstPageIndicator: SkeletonPostList(),
        );

  @override
  dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView(refreshable: false);
  }
}
