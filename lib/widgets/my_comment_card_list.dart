import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/model/my_comment.dart';
import 'package:zhihu_demo/utils/paging_manager.dart';

import 'my_comment_card.dart';

class MyCommentCardList extends StatefulWidget {
  const MyCommentCardList({Key? key}) : super(key: key);

  @override
  _MyCommentCardListState createState() => _MyCommentCardListState();
}

class _MyCommentCardListState extends State<MyCommentCardList> {

  final PagingManager<MyComment> _pagingManager = PagingManager(
      Constants.defaultPageSize,
          (page, pageSize) {
        return Future.delayed(
          const Duration(seconds: 1),
              () => myComments.sublist(
              page * pageSize, min((page + 1) * pageSize, posts.length)
          ),
        );
      },
          (context, item, index) => MyCommentCard(item)
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


