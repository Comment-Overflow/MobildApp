import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class FollowingCommentList extends StatefulWidget {
  const FollowingCommentList({Key? key}) : super(key: key);

  @override
  _FollowingCommentListState createState() => _FollowingCommentListState();
}

class _FollowingCommentListState extends State<FollowingCommentList> {
  final PagingManager<SearchedPost> _pagingManager = PagingManager(
    Constants.defaultPageSize,
    (page, pageSize) async {
      final Response response =
          await PostService.getFollowingComments(page, pageSize);
      return (response.data as List)
          .map((e) => SearchedPost.fromJson(e))
          .toList();
    },
    (context, item, index) => CommentSummaryCard(item),
    emptyIndicatorTitle: Constants.commentEmptyIndicatorTitle,
    emptyIndicatorSubtitle: Constants.followingCommentEmptyIndicatorSubtitle,
  );

  @override
  dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView();
  }
}
