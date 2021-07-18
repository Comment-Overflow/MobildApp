import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/widgets/chat_card.dart';

class RecentChatList extends StatefulWidget {
  RecentChatList({Key? key}) : super(key: key);

  @override
  _RecentChatListState createState() => _RecentChatListState();
}

class _RecentChatListState extends State<RecentChatList> {
  late List<Chat> _recentChats;

  @override
  void initState() {
    super.initState();
    getRecentChats();
  }

  void getRecentChats() {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    setState(() {
      _recentChats = recentChats;
    });
  }

  Future _onRefresh() async {
    getRecentChats();
    print("onRefresh");
    // monitor network fetch
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    print("onLoading");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNoData()
  }

  @override
  Widget build(BuildContext context) {
    return _recentChats.length == 0 ? _buildNoChatPrompt() : _buildChatList();
  }

  Widget _buildNoChatPrompt() {
    return Expanded(
      child: Center(
        child: Text("没有消息",
          style: TextStyle(
            color: Colors.grey,fontSize: 20.0,
        ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: AdaptiveRefresher(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _recentChats.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatCard(_recentChats[index], () {
              // TODO: Delete the chat from local file.
              // TODO: Delete the chat from server. (?)
              setState(() {
                _recentChats.removeAt(index);
              });
              getRecentChats();
            });
          },
        ),
      ),
    );
  }
}
