import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/widgets/chat_card.dart';

class RecentChatList extends StatelessWidget {

  late final List<Chat> _recentChats;

  RecentChatList({Key? key}) : super(key: key) {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    _recentChats = recentChats;
  }

  Future _onRefresh() async {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    print("onRefresh");
    // monitor network fetch
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    print("onLoading");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // TODO: Use gzd's adaptive refresher.
      child: AdaptiveRefresher(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _recentChats.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatCard(_recentChats[index], () {
              // TODO: Delete the chat from local file.
              // TODO: Delete the chat from server. (?)
              // TODO: Get cached chats from local file.
              // TODO: Get real chats from server.
            });
          },
        ),
      ),
    );
  }
}