import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:badges/badges.dart';

class ChatCard extends StatelessWidget {
  final Chat _chat;
  final VoidCallback _deleteChat;
  final double _horizontalGap = 10.0;

  const ChatCard(this._chat, this._deleteChat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container card = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(Constants.defaultCardPadding),
      height: Constants.defaultChatCardHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAvatar(_chat.chatter.userId, Constants.defaultChatListAvatarSize,
              imageContent: this._chat.chatter.avatarUrl, canJump: false),
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
                    AutoSizeText(
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
                      child: AutoSizeText(
                        _chat.lastMessageContent,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        maxFontSize: (Constants.chatListBaselineSize * 0.9).floorToDouble(),
                        minFontSize: (Constants.chatListBaselineSize * 0.83).floorToDouble(),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: _horizontalGap),
                    AutoSizeText(
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
          Navigator.of(context).pushNamed(RouteGenerator.privateChatRoute,
              arguments: _chat.chatter);
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.22,
          child: card,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '??????',
              color: Colors.red,
              icon: Icons.delete,
              onTap: _deleteChat,
            ),
          ],
        ));
  }

  Widget _buildUnreadPrompt() {
    return _chat.unreadCount == 0
        ? Container()
        : _chat.unreadCount < 100
            ? CircleAvatar(
                radius: Constants.chatListBaselineSize * 0.6,
                backgroundColor: Colors.red,
                child: AutoSizeText(
                  GeneralUtils.getBadgeString(_chat.unreadCount)!,
                  style: TextStyle(
                    fontSize: _chat.unreadCount < 10
                        ? Constants.chatListBaselineSize * 0.8
                        : Constants.chatListBaselineSize * 0.72,
                    color: Colors.white,
                  ),
                ),
              )
            : Badge(
                elevation: 0,
                toAnimate: false,
                shape: BadgeShape.square,
                borderRadius:
                    BorderRadius.circular(Constants.chatListBaselineSize),
                padding: EdgeInsets.all(Constants.chatListBaselineSize * 0.15),
                badgeContent: AutoSizeText(
                  GeneralUtils.getBadgeString(_chat.unreadCount)!,
                  style: TextStyle(
                    fontSize: Constants.chatListBaselineSize * 0.7,
                    color: Colors.white,
                  ),
                ),
              );
  }
}
