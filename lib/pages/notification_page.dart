import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:comment_overflow/widgets/chat_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/notification_button_list.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _getRecentChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: Constants.defaultAppBarElevation,
        title: Text(
          "消息",
          style: CustomStyles.pageTitleStyle,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: AdaptiveRefresher(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Container(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Constants.defaultNotificationButtonSize * 0.7,
                    horizontal: Constants.defaultNotificationButtonSize * 0.35),
                child: NotificationButtonList(
                    Constants.defaultNotificationButtonSize),
              ),
            )),
            context.watch<RecentChatsProvider>().recentChats.length == 0
                ? _buildNoChatPrompt()
                : _buildChatList(),
          ],
        ),
      ),
    );
  }

  Future _onRefresh() async {
    _getRecentChats();
  }

  Widget _buildNoChatPrompt() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          "没有消息",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    List<Chat> recentChats = context.watch<RecentChatsProvider>().recentChats;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ChatCard(recentChats[index], () {
            ChatService.deleteChat(recentChats[index].chatter.userId);
            context.read<RecentChatsProvider>().removeAt(index);
          });
        },
        childCount: recentChats.length,
      ),
    );
  }

  Future _getRecentChats() async {
    Response<dynamic> response = await ChatService.getRecentChats();
    List chatsResponse = response.data as List;
    List<Chat> recentChats = [];
    Map<int, Chat> chatMap = Map();
    for (Map chatResponse in chatsResponse) {
      Chat chat = Chat.fromJson(chatResponse);
      recentChats.add(chat);
      chatMap.putIfAbsent(chat.chatter.userId, () => chat);
    }
    context.read<RecentChatsProvider>().updateAll(recentChats, chatMap);
  }
}
