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
        elevation: Constants.defaultAppBarElevation,
        title: Text(
          "消息",
          style: CustomStyles.pageTitleStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Constants.defaultNotificationButtonSize * 0.7,
                horizontal: Constants.defaultNotificationButtonSize * 0.35),
            child:
                NotificationButtonList(Constants.defaultNotificationButtonSize),
          ),
          Divider(height: 0.1, thickness: 0.8),
          RecentChatList(),
        ],
      ),
    );
  }
}
