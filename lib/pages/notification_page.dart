import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/notification_button_list.dart';
import 'package:comment_overflow/widgets/recent_chat_list.dart';

class NotificationPage extends StatelessWidget {

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "消息",
          style: CustomStyles.pageTitleStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Constants.defaultNotificationButtonSize,
                horizontal: Constants.defaultNotificationButtonSize * 0.35
            ),
            child: NotificationButtonList(Constants.defaultNotificationButtonSize),
          ),
          RecentChatList(),
        ],
      ),
    );
  }
}