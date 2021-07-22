import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// For use in ApproveMeCard, CommentMeCard and FollowMeCard.
/// Displays user avatar, user name and action time.
class UserAvatarWithNameAndDate extends StatelessWidget {
  static const _map = {
    UserActionType.approval: "赞同了你的发言",
    UserActionType.reply: "回复了你的发言",
    UserActionType.follow: "关注了你",
    UserActionType.star: "收藏了你的帖子",
  };
  final UserInfo _userInfo;
  final DateTime _time;
  final UserActionType _userActionType;
  final double avatarSize;
  // Gap between avatar and text.
  final double horizontalGap;
  // Gap between lines of text.
  final double verticalGap;

  const UserAvatarWithNameAndDate(
    this._userInfo,
    this._time,
    this._userActionType, {
    Key? key,
    this.avatarSize: 40.0,
    this.horizontalGap: 10.0,
    this.verticalGap: 7.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _horizontalGap = SizedBox(width: horizontalGap);
    final _verticalGap = SizedBox(height: verticalGap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(this.avatarSize, image: NetworkImage(_userInfo.avatarUrl)),
        _horizontalGap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
                text: TextSpan(
              children: [
                // User name.
                TextSpan(
                    text: this._userInfo.userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    )),
                TextSpan(
                  text: ' ',
                ),
                TextSpan(
                  text: _map[this._userActionType],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                )
              ],
            )),
            _verticalGap,
            Text(
              GeneralUtils.getDefaultTimeString(this._time),
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }
}
