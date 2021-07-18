import 'package:comment_overflow/widgets/adaptive_refresher.dart';
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
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, value) {
          return [
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
          ];
        },
        body: Container(child: RecentChatList()),
      ),
    );
  }

  Future _onRefresh() async {
    // getRecentChats();
    print("Notification Page onRefresh");
    // monitor network fetch
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }
}
