import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/pages/chat_room_page.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatCard extends StatelessWidget {
  final Chat _chat;
  final VoidCallback _deleteChat;
  final double _horizontalGap = 10.0;

  const ChatCard(this._chat, this._deleteChat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container card = Container(
      padding: EdgeInsets.fromLTRB(
          Constants.defaultCardPadding * 0.4,
          Constants.defaultCardPadding,
          Constants.defaultCardPadding,
          Constants.defaultCardPadding),
      height: Constants.defaultChatCardHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAvatar(Constants.defaultChatListAvatarSize),
          SizedBox(width: _horizontalGap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _chat.chatter.userName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.chatListBaselineSize,
                      ),
                    ),
                    _buildUnreadPrompt(),
                  ],
                ),
                SizedBox(height: Constants.chatListBaselineSize * 0.4),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _chat.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: Constants.chatListBaselineSize * 0.9,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: _horizontalGap),
                    Text(
                      GeneralUtils.getDefaultTimeString(_chat.time),
                      style: TextStyle(
                        fontSize: Constants.chatListBaselineSize * 0.7,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ChatRoomPage(_chat.chatter);
          }));
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.22,
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

  Widget _buildUnreadPrompt() {
    return _chat.unreadCount == 0
        ? Container(height: 0, width: 0)
        : CircleAvatar(
            radius: Constants.chatListBaselineSize / 2,
            backgroundColor: CustomColors.UnreadChatRed,
            child: Text(
              _chat.unreadCount.toString(),
              style: TextStyle(
                fontSize: Constants.chatListBaselineSize * 0.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
  }
}
