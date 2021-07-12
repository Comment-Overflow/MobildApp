import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/fake_data/posts.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/utils/paging_manager.dart';
import 'package:zhihu_demo/widgets/post_card.dart';

class PostCardList extends StatefulWidget {
  const PostCardList({Key? key}) : super(key: key);

  @override
  _PostCardListState createState() => _PostCardListState();
}

class _PostCardListState extends State<PostCardList> {

  final PagingManager<Post> _pagingManager = PagingManager(
      Constants.pageSize,
      (page, pageSize) {
        return Future.delayed(
          const Duration(seconds: 1),
          () => posts.sublist(
            page * pageSize, min((page + 1) * pageSize, posts.length)
          ),
        );
      },
      (context, item, index) => PostCard(item)
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


