import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/model/routing_dto/jump_post_dto.dart';
import 'package:comment_overflow/model/user_action_record.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name_and_date.dart';
import 'package:dio/dio.dart';
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
                    child: GestureDetector(
                      onTap: () =>
                          _jumpToPost(_starRecord.starredPost, context),
                      child: QuoteCard(_starRecord.starredPost),
                    ),
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
                    child: GestureDetector(
                        onTap: () => _jumpToPost(
                            _approvalRecord.approvedComment, context),
                        child: QuoteCard(_approvalRecord.approvedComment)),
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
                    child: GestureDetector(
                        onTap: () =>
                            _jumpToPost(_replyRecord.repliedQuote, context),
                        child: QuoteCard(_replyRecord.repliedQuote)),
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
                    _followRecord.userInfo.userId,
                    _followRecord.userInfo.userName,
                    _followRecord.followStatus,
                  ),
                ])));
  }
}

_jumpToPost(Quote quote, BuildContext context) async {
  try {
    final Response response =
        await PostService.getPostByComment(quote.commentId);
    print(response.data);
    Post _post = Post.fromJson(response.data);
    Navigator.of(context).pushNamed(RouteGenerator.postRoute,
        arguments: JumpPostDTO(_post, pageIndex: quote.floor));
  } on DioError catch (e) {
    print(e.type);
    if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.other) {
      MessageBox.showToast(msg: "网络连接异常", messageBoxType: MessageBoxType.Error);
    } else {
      MessageBox.showToast(
          msg: "服务器开小差了，过会再试试", messageBoxType: MessageBoxType.Error);
    }
  }
}
