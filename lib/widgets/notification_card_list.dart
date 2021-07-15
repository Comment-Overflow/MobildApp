import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/model/notification_msg.dart';
import 'package:zhihu_demo/utils/paging_manager.dart';
import 'package:zhihu_demo/widgets/notification_card.dart';

class NotificationCardList extends StatefulWidget {
  const NotificationCardList({Key? key}) : super(key: key);

  @override
  _NotificationCardListState createState() => _NotificationCardListState();
}

class _NotificationCardListState extends State<NotificationCardList> {

  final PagingManager<NotificationMsg> _pagingManager = PagingManager(
      Constants.defaultNotificationPageSize,
          (page, pageSize) {
        return Future.delayed(
          const Duration(seconds: 1),
              () => notifications.sublist(
              page * pageSize, min((page + 1) * pageSize, posts.length)
          ),
        );
      },
          (context, item, index) => NotificationCard(item)
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


