import 'package:badges/badges.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/pages/home_page.dart';
import 'package:comment_overflow/pages/personal_page.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:comment_overflow/pages/notification_page.dart';

class PagesContainer extends StatefulWidget {
  const PagesContainer({Key? key}) : super(key: key);

  @override
  _PagesContainerState createState() => _PagesContainerState();
}

class _PagesContainerState extends State<PagesContainer> {
  int _index = 0;

  //小红点，null就不显示，String就显示String的内容
  String? badge;
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
        {1: badge},
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
        initialActiveIndex: 0,
      ),
    );
  }
}
