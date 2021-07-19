import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyFollowUserList extends StatefulWidget {
  const MyFollowUserList({Key? key}) : super(key: key);

  @override
  _MyFollowUserListState createState() => _MyFollowUserListState();
}

class _MyFollowUserListState extends State<MyFollowUserList> {
  final PagingManager<UserCardInfo> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => users.sublist(
          page * pageSize, min((page + 1) * pageSize, posts.length)),
    );
  }, (context, item, index) => UserCard(item));

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
