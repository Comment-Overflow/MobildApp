import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_post_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RecommendPostList extends StatefulWidget {
  const RecommendPostList({Key? key}) : super(key: key);

  @override
  _RecommendPostListState createState() => _RecommendPostListState();
}

class _RecommendPostListState extends State<RecommendPostList> {
  final PagingManager<Post> _pagingManager = PagingManager(
    Constants.int32MaxValue,
    (page, pageSize) async {
      final Response response = await PostService.getRecommendPosts(
          PostQueryDTO(pageNum: page, pageSize: pageSize));
      var jsonArray = response.data as List;
      return jsonArray.map((e) => Post.fromJson(e)).toList();
    },
    (context, item, index) => PostCard(item),
    emptyIndicatorTitle: Constants.noRecommendationIndicatorTitle,
    emptyIndicatorSubtitle: Constants.noRecommendationIndicatorSubtitle,
    firstPageIndicator: SkeletonPostList(),
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
