import 'package:bubble/bubble.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/socket_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';

class ChatMessage extends StatefulWidget {
  final Message _message;
  late final ChatterType _type;

  ChatMessage(this._message, {Key? key}) : super(key: key) {
    _type = _message.sender.userId == currentUserId
        ? ChatterType.Me
        : ChatterType.Other;
  }

  @override
  ChatMessageState createState() => ChatMessageState(_message);
}

class ChatMessageState extends State<ChatMessage> {
  bool _loading = true;
  final Message _message;

  Message get message => _message;

  ChatMessageState(this._message);

  @override
  void initState() {
    super.initState();
    // SocketUtil().sendMessage(widget.key as GlobalKey<ChatMessageState>);
  }

  @override
  Widget build(BuildContext context) {
    if (widget._type == ChatterType.Me)
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loading
              ? SizedBox(
                  height: Constants.defaultChatRoomFontSize,
                  width: Constants.defaultChatRoomFontSize,
                  child: CupertinoActivityIndicator(
                      radius: Constants.defaultChatRoomFontSize * 0.5))
              : Container(),
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
                child: _buildContent(),
              ),
              widget._message.time == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: Constants.chatTimeVerticalPadding,
                          right: Constants.chatTimeHorizontalPadding),
                      child: Text(
                        GeneralUtils.getChatTimeString(widget._message.time!),
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
                child: _buildContent(),
              ),
              widget._message.time == null
                  ? Container() :
              Padding(
                padding: const EdgeInsets.only(
                    top: Constants.chatTimeVerticalPadding,
                    left: Constants.chatTimeHorizontalPadding),
                child: Text(
                  GeneralUtils.getChatTimeString(widget._message.time!),
                  style: CustomStyles.chatMessageTimeStyle,
                ),
              ),
            ],
          ),
        ],
      );
  }

  Widget _buildContent() {
    if (widget._message.type == MessageType.Text)
      return Container(
          constraints:
              BoxConstraints(maxWidth: Constants.defaultMaxBubbleWidth),
          child: Text(widget._message.content, textAlign: TextAlign.left));
    else if (widget._message.type == MessageType.Image)
      return Image.network(
        widget._message.content,
        fit: BoxFit.scaleDown,
        width: Constants.defaultMaxBubbleWidth,
      );
    else
      return Image.file(
        widget._message.content,
        fit: BoxFit.scaleDown,
        width: Constants.defaultMaxBubbleWidth,
      );
  }

  void finishSending() {
    setState(() {
      _loading = false;
    });
  }
}
