import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/my_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyPostCardList extends StatefulWidget {
  const MyPostCardList({Key? key}) : super(key: key);

  @override
  _MyPostCardListState createState() => _MyPostCardListState();
}

class _MyPostCardListState extends State<MyPostCardList> {
  final PagingManager<Post> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => posts.sublist(
          page * pageSize, min((page + 1) * pageSize, posts.length)),
    );
  }, (context, item, index) => MyPostCard(item));

  @override
  dispose() {
    super.dispose();
    _pagingManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView();
  }
}
