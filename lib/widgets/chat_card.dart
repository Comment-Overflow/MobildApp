import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/pages/chat_room_page.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatCard extends StatelessWidget {
  final Chat _chat;
  final VoidCallback _deleteChat;

  const ChatCard(this._chat, this._deleteChat, {Key? key}) : super(key: key);

  String getDisplayTime() {
    if (_chat.time.isToday)
      return _chat.time.format('HH:mm');
    else if (_chat.time.isYesterday)
      return '昨天';
    else
      return _chat.time.format('yyyy-MM-dd');
  }

  @override
  Widget build(BuildContext context) {
    Widget? unreadPrompt = _chat.unreadCount == 0
        ? Container(height: 0, width: 0)
        : CircleAvatar(
            radius: 9.0,
            backgroundColor: CustomColors.UnreadChatRed,
            child: Text(
              _chat.unreadCount.toString(),
              style: CustomStyles.unreadChatTextStyle,
            ),
          );

    Container card = Container(
      padding: EdgeInsets.fromLTRB(
          Constants.defaultCardPadding * 0.4,
          Constants.defaultCardPadding,
          Constants.defaultCardPadding,
          Constants.defaultCardPadding),
      height: Constants.defaultChatCardHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 20,
            child: UserAvatar(Constants.defaultChatListAvatarSize),
          ),
          Expanded(
            flex: 59,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
                Expanded(
                  flex: 45,
                  child: Text(
                    _chat.chatter.userName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomStyles.userNameStyle,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 40,
                  child: Text(
                    _chat.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomStyles.lastMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 12,
                  child: Container(),
                ),
                Expanded(flex: 50, child: unreadPrompt),
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
                Expanded(
                  flex: 28,
                  child: Text(
                    getDisplayTime(),
                    style: CustomStyles.lastChatTimeTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ChatRoomPage(_chat);
          }));
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: card,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '删除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: _deleteChat,
            ),
          ],
        ));
  }
}
