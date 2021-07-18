import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/notification_message.dart';
import 'package:comment_overflow/model/user_action_record.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name_and_date.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'follow_button.dart';

class NotificationCard extends StatelessWidget {
  final NotificationMessage _notificationMessage;

  NotificationCard(this._notificationMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeContent = "";
    switch (_notificationMessage.type) {
      case NotificationType.approvePost:
        typeContent = "赞同了你的帖子${_notificationMessage.title}";
        break;
      case NotificationType.approveComment:
        typeContent =
            "赞同了你在帖子${_notificationMessage.title}中的发言${_notificationMessage.comment}";
        break;
      case NotificationType.reply:
        typeContent =
            "回复了你的帖子${_notificationMessage.title}:${_notificationMessage.comment}";
        break;
      case NotificationType.attention:
        typeContent = "收藏了你的帖子${_notificationMessage.title}";
        break;
      default:
        typeContent = "关注了你";
    }

    return Card(
      elevation: Constants.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(_notificationMessage.imageSize,
                    image: _notificationMessage.image),
                SizedBox(width: _notificationMessage.gap),
                Expanded(
                    child: Text(
                  _notificationMessage.userInfo.title + typeContent,
                  style: _notificationMessage.textStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
          ]),
        ),
        onTap: () => {},
      ),
    );
  }
}

class StarNotificationCard extends StatelessWidget {
  static const _gap = SizedBox(height: 5.0);
  final StarRecord _starRecord;

  const StarNotificationCard(this._starRecord, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UserAvatarWithNameAndDate(
                  _starRecord.userInfo, _starRecord.time, UserActionType.star),
              _gap,
              QuoteCard(_starRecord.starredPost),
            ])));
  }
}

class ApprovalNotificationCard extends StatelessWidget {
  static const _gap = SizedBox(height: 5.0);
  final ApprovalRecord _approvalRecord;

  const ApprovalNotificationCard(this._approvalRecord, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UserAvatarWithNameAndDate(_approvalRecord.userInfo,
                  _approvalRecord.time, UserActionType.approval),
              _gap,
              QuoteCard(_approvalRecord.approvedComment),
            ])));
  }
}

class ReplyNotificationCard extends StatelessWidget {
  static const _gap = SizedBox(height: 5.0);
  final ReplyRecord _replyRecord;

  const ReplyNotificationCard(this._replyRecord, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UserAvatarWithNameAndDate(_replyRecord.userInfo,
                  _replyRecord.time, UserActionType.reply),
              _gap,
              Text(_replyRecord.content, style: CustomStyles.postContentStyle),
              _gap,
              QuoteCard(_replyRecord.repliedQuote),
            ])));
  }
}

class FollowNotificationCard extends StatelessWidget {
  final FollowRecord _followRecord;

  const FollowNotificationCard(this._followRecord, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAvatarWithNameAndDate(
                    _followRecord.userInfo,
                    _followRecord.time,
                    UserActionType.follow,
                    avatarSize: 50.0,
                    verticalGap: 12.0,
                  ),
                  FollowButton(
                    _followRecord.userInfo.userName,
                    _followRecord.followStatus,
                  ),
                ])));
  }
}
