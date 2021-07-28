import 'dart:io';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
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
                        _chat.lastMessageContent,
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
          UserInfo chatter =
              UserInfo(Platform.isIOS ? 1 : 2, _chat.chatter.userName);
          Navigator.of(context)
              .pushNamed(RouteGenerator.privateChatRoute, arguments: chatter);
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
        ? Container()
        : _chat.unreadCount < 100
            ? CircleAvatar(
                radius: Constants.chatListBaselineSize * 0.6,
                backgroundColor: Colors.red,
                child: Text(
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
                badgeContent: Text(
                  GeneralUtils.getBadgeString(_chat.unreadCount)!,
                  style: TextStyle(
                    fontSize: Constants.chatListBaselineSize * 0.7,
                    color: Colors.white,
                  ),
                ),
              );
  }
}
