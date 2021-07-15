import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/notification_message.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationCardList extends StatefulWidget {
  const NotificationCardList({Key? key}) : super(key: key);

  @override
  _NotificationCardListState createState() => _NotificationCardListState();
}

class _NotificationCardListState extends State<NotificationCardList> {
  final PagingManager<NotificationMessage> _pagingManager =
      PagingManager(Constants.defaultNotificationPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => notifications.sublist(
          page * pageSize, min((page + 1) * pageSize, posts.length)),
    );
  }, (context, item, index) => NotificationCard(item));

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
