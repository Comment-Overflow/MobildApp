import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/utils/paging_manager.dart';
import 'package:zhihu_demo/widgets/my_post_card.dart';

class MyPostCardList extends StatefulWidget {
  const MyPostCardList({Key? key}) : super(key: key);

  @override
  _MyPostCardListState createState() => _MyPostCardListState();
}

class _MyPostCardListState extends State<MyPostCardList> {

  final PagingManager<Post> _pagingManager = PagingManager(
      Constants.defaultPageSize,
          (page, pageSize) {
        return Future.delayed(
          const Duration(seconds: 1),
              () => posts.sublist(
              page * pageSize, min((page + 1) * pageSize, posts.length)
          ),
        );
      },
          (context, item, index) => MyPostCard(item)
  );

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


