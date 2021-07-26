import 'dart:convert';
import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostCardList extends StatefulWidget {
  const PostCardList({Key? key}) : super(key: key);

  @override
  _PostCardListState createState() => _PostCardListState();
}

class _PostCardListState extends State<PostCardList> {
  final PagingManager<Post> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) async {
    var response = await PostService.getPosts(
        PostQueryDTO(tag: PostTag.Life, pageNum: page, pageSize: pageSize));
    var postObjJson = response.data['content'] as List;
    return postObjJson.map((e) => Post.fromJson(e)).toList();
  }, (context, item, index) => PostCard(item),
          emptyIndicatorTitle: Constants.browsePostIndicatorTitle,
          emptyIndicatorSubtitle: Constants.browsePostEmptyIndicatorSubtitle);

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
