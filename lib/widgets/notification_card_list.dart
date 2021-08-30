import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_action_record.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/notification_card.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_notification_list.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_user_list.dart';
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
    var _itemBuilder;

    switch (userActionType) {
      case UserActionType.approval:
        _itemBuilder = (context, item, index) => ApprovalNotificationCard(item);
        this._pagingManager = PagingManager(
            Constants.defaultNotificationPageSize, (page, pageSize) async {
          var jsonArray = (await NotificationService.getNotification(
                  page, pageSize, "/notifications/approvals"))
              .data['content'] as List;
          return jsonArray
              .map((json) => ApprovalRecord.fromJson(json))
              .toList();
        }, _itemBuilder,
            firstPageIndicator: SkeletonNotificationCardList(),
            emptyIndicatorTitle: Constants.noApprovalIndicatorTitle);
        break;
      case UserActionType.reply:
        _itemBuilder = (context, item, index) => ReplyNotificationCard(item);
        this._pagingManager = PagingManager(
            Constants.defaultNotificationPageSize, (page, pageSize) async {
          var jsonArray = (await NotificationService.getNotification(
                  page, pageSize, "/notifications/replies"))
              .data as List;
          return jsonArray.map((json) => ReplyRecord.fromJson(json)).toList();
        }, _itemBuilder,
            firstPageIndicator: SkeletonNotificationCardList(),
            emptyIndicatorTitle: Constants.noReplyIndicatorTitle);
        break;
      case UserActionType.star:
        _itemBuilder = (context, item, index) => StarNotificationCard(item);
        this._pagingManager = PagingManager(
            Constants.defaultNotificationPageSize, (page, pageSize) async {
          var jsonArray = (await NotificationService.getNotification(
                  page, pageSize, "/notifications/stars"))
              .data['content'] as List;
          return jsonArray.map((json) => StarRecord.fromJson(json)).toList();
        }, _itemBuilder,
            firstPageIndicator: SkeletonNotificationCardList(),
            emptyIndicatorTitle: Constants.noStarredIndicatorTitle);
        break;
      case UserActionType.follow:
        _itemBuilder = (context, item, index) => FollowNotificationCard(item);
        this._pagingManager = PagingManager(
            Constants.defaultNotificationPageSize, (page, pageSize) async {
          var jsonArray = (await NotificationService.getNotification(
                  page, pageSize, "/notifications/followers"))
              .data['content'] as List;
          return jsonArray.map((json) => FollowRecord.fromJson(json)).toList();
        }, _itemBuilder,
            firstPageIndicator: SkeletonUserList(),
            emptyIndicatorTitle: Constants.noFollowNotificationTitle);
        break;
    }
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
