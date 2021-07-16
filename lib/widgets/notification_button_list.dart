import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/pages/home_page.dart';

class NotificationButtonList extends StatelessWidget {

  final double _buttonSize;
  late final TextStyle _notificationButtonTextStyle;
  late final SizedBox _gap;

  NotificationButtonList(this._buttonSize, {Key? key}) : super(key: key) {
    _notificationButtonTextStyle = TextStyle(
      fontSize: _buttonSize * 0.4,
      fontWeight: FontWeight.bold,
      color: Colors.grey[800],
    );
    _gap = SizedBox(height: _buttonSize * 0.15);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 25,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
              CupertinoPageRoute(builder: (context) {
                // TODO: ScrollViewPage
                return HomePage();
              }));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomStyles.getDefaultLightNotThumbUpIcon(size: _buttonSize, color: Colors.black),
                _gap,
                Text("赞同", style: _notificationButtonTextStyle),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 25,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) {
                    // TODO: ScrollViewPage
                    return HomePage();
                  }));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomStyles.getDefaultReplyIcon(size: _buttonSize, color: Colors.black),
                _gap,
                Text("回复", style: _notificationButtonTextStyle),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 25,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) {
                    // TODO: ScrollViewPage
                    return HomePage();
                  }));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomStyles.getDefaultNotStarIcon(size: _buttonSize, color: Colors.black),
                _gap,
                Text("收藏", style: _notificationButtonTextStyle),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 25,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) {
                    // TODO: ScrollViewPage
                    return HomePage();
                  }));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomStyles.getDefaultUnfilledFollowerIcon(size: _buttonSize, color: Colors.black),
                _gap,
                Text("关注", style: _notificationButtonTextStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
