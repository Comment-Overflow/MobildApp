import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/providers/recent_chats.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:comment_overflow/widgets/chat_card.dart';
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
  late List<Chat> _recentChats;

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
            _recentChats.length == 0 ? _buildNoChatPrompt() : _buildChatList(),
          ],
        ),
      ),
    );
  }

  void _getRecentChats() {
    // TODO: Get cached chats from local file.
    // TODO: Get real chats from server.
    setState(() {
      _recentChats = recentChats;
    });
  }

  Future _onRefresh() async {
    // getRecentChats();
    print("Notification Page onRefresh");
    // monitor network fetch
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  Widget _buildNoChatPrompt() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          "没有消息",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    List<Chat> recentChats = context.watch<RecentChats>().recentChats;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ChatCard(recentChats[index], () {
            // TODO: Delete the chat from local file.
            // TODO: Delete the chat from server. (?)
            context.read<RecentChats>().removeAt(index);
            _getRecentChats();
          });
        },
        childCount: recentChats.length,
      ),
    );
  }
}
