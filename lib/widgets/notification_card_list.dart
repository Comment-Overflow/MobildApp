import 'dart:convert';
import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_action_record.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/notification_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationCardList extends StatefulWidget {
  final UserActionType _userActionType;
  const NotificationCardList(this._userActionType, {Key? key})
      : super(key: key);

  @override
  _NotificationCardListState createState() =>
      _NotificationCardListState(_userActionType);
}

class _NotificationCardListState extends State<NotificationCardList> {
  late PagingManager _pagingManager;

  _NotificationCardListState(userActionType) {
    List _dataList = [];
    var _itemBuilder;

    switch (userActionType) {
      case UserActionType.approval:
        _dataList = approvalRecords;
        _itemBuilder = (context, item, index) => ApprovalNotificationCard(item);
        break;
      case UserActionType.reply:
        _dataList = replyRecords;
        _itemBuilder = (context, item, index) => ReplyNotificationCard(item);
        break;
      case UserActionType.star:
        _dataList = starRecords;
        _itemBuilder = (context, item, index) => StarNotificationCard(item);
        break;
      case UserActionType.follow:
        _dataList = followRecords;
        _itemBuilder = (context, item, index) => FollowNotificationCard(item);
        break;
    }

    // this._pagingManager =
    //     PagingManager(Constants.defaultNotificationPageSize, (page, pageSize) async {
    //       Response response = await HttpUtil().dio.get('/notifications/approvals', queryParameters: {
    //         'page': page, 'pageSize': pageSize
    //       });
    //       var jsonArray = response.data as List;
    //       return jsonArray.map((json) => ApprovalRecord.fromJson(json)).toList();
    //     }, _itemBuilder);
    this._pagingManager =
        PagingManager(Constants.defaultNotificationPageSize, (page, pageSize) {
          return Future.delayed(
            const Duration(seconds: 1),
                () => _dataList.sublist(
                page * pageSize, min((page + 1) * pageSize, _dataList.length)),
          );
        }, _itemBuilder);
  }



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
