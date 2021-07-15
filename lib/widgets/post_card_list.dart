import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
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
      PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => posts.sublist(
          page * pageSize, min((page + 1) * pageSize, posts.length)),
    );
  }, (context, item, index) => PostCard(item));

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
