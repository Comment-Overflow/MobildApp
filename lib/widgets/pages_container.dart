import 'package:comment_overflow/pages/home_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PagesContainer extends StatefulWidget {
  const PagesContainer({Key? key}) : super(key: key);

  @override
  _PagesContainerState createState() => _PagesContainerState();
}

class _PagesContainerState extends State<PagesContainer> {
  int _index = 0;
  final _pages = <Widget>[HomePage(), HomePage(), HomePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pages[_index],
      bottomNavigationBar: ConvexAppBar(
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
