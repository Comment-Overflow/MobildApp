import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/widgets/chat_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentChatList extends StatelessWidget {

  late final List<Chat> _recentChats;
  final RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  RecentChatList({Key? key}) : super(key: key) {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    _recentChats = recentChats;
  }

  void _onRefresh() async {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    print("onRefresh");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print("onLoading");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // TODO: Use gzd's adaptive refresher.
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          refresh: null,
          complete: Container(),
          // color: Colors.blueAccent,
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
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