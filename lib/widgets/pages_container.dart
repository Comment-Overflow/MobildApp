import 'package:comment_overflow/pages/home_page.dart';
import 'package:comment_overflow/pages/personal_page.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:comment_overflow/pages/notification_page.dart';
import 'package:provider/provider.dart';

class PagesContainer extends StatefulWidget {
  final int defaultIndex;
  PagesContainer({Key? key, this.defaultIndex = 0}) : super(key: key);

  @override
  _PagesContainerState createState() => _PagesContainerState(defaultIndex);
}

class _PagesContainerState extends State<PagesContainer> {
  int _index;

  _PagesContainerState(this._index);
  final _pages = <Widget>[
    HomePage(),
    NotificationPage(),
    FutureBuilder<int>(
      future: GeneralUtils.getCurrentUserId(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Container();
        return PersonalPage(snapshot.data!, false);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pages[_index],
      bottomNavigationBar: ConvexAppBar.badge(
        {
          1: GeneralUtils.getBadgeString(
              context.watch<RecentChatsProvider>().totalUnreadCount)
        },
        badgeMargin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
        elevation: 0.5,
        style: TabStyle.flip,
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).accentColor,
        color: Colors.grey,
        height: 55,
        items: [
          TabItem(icon: Icons.home, title: '首页'),
          TabItem(icon: Icons.message, title: '消息'),
          TabItem(icon: Icons.person, title: '我的'),
        ],
        onTap: (int i) => setState(() {
          this._index = i;
        }),
        initialActiveIndex: _index,
      ),
    );
  }
}
