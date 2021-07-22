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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: QuoteCard(_starRecord.starredPost),
                  ),
                ],
              ),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: QuoteCard(_approvalRecord.approvedComment),
                  ),
                ],
              ),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: QuoteCard(_replyRecord.repliedQuote),
                  ),
                ],
              ),
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
