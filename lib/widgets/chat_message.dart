import 'package:bubble/bubble.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';

class ChatMessage extends StatelessWidget {
  final Message _message;
  late final ChatterType _type;

  ChatMessage(this._message) {
    _type = _message.sender.userId == currentUserId
        ? ChatterType.Me
        : ChatterType.Other;
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = _message.type == MessageType.Text
        ? Container(
            constraints:
                BoxConstraints(maxWidth: Constants.defaultMaxBubbleWidth),
            child: Text(_message.content, textAlign: TextAlign.left))
        : Image.network(
            _message.content,
            fit: BoxFit.scaleDown,
            width: Constants.defaultMaxBubbleWidth,
          );

    if (_type == ChatterType.Me)
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bubble(
                margin: BubbleEdges.only(top: 10),
                padding: BubbleEdges.all(8),
                elevation: 0.3,
                alignment: Alignment.topRight,
                nip: BubbleNip.rightTop,
                color: CustomColors.chatBubbleBlue,
                child: content,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: Constants.chatTimeVerticalPadding,
                    right: Constants.chatTimeHorizontalPadding),
                child: Text(
                  getChatTime(_message.time),
                  style: CustomStyles.chatMessageTimeStyle,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                Constants.defaultChatRoomAvatarPadding, 0, 0, 0),
            child: UserAvatar(Constants.defaultChatRoomAvatarSize),
          ),
        ],
      );
    else
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                0, 0, Constants.defaultChatRoomAvatarPadding, 0),
            child: UserAvatar(Constants.defaultChatRoomAvatarSize),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bubble(
                margin: BubbleEdges.only(top: 10),
                padding: BubbleEdges.all(8),
                elevation: 0.3,
                alignment: Alignment.topLeft,
                nip: BubbleNip.leftTop,
                child: content,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: Constants.chatTimeVerticalPadding,
                    left: Constants.chatTimeHorizontalPadding),
                child: Text(
                  getChatTime(_message.time),
                  style: CustomStyles.chatMessageTimeStyle,
                ),
              ),
            ],
          ),
        ],
      );
  }
}
