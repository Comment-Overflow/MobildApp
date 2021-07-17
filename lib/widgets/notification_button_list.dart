import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/pages/home_page.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/multiple_widget_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.homeRoute,
              )),
              [
                Icon(CupertinoIcons.heart,
                    size: _buttonSize, color: Colors.black),
                _gap,
                Text("赞同", style: _notificationButtonTextStyle),
              ],
            ),
          ),
          Expanded(
            flex: 25,
            child: InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  // TODO: ScrollViewPage
                  return HomePage();
                }));
              },
              child: MultipleWidgetButton(
                RouteGenerator.generateRoute(RouteSettings(
                  name: RouteGenerator.homeRoute,
                )),
                [
                  Icon(CupertinoIcons.text_bubble,
                      size: _buttonSize, color: Colors.black),
                  _gap,
                  Text("回复", style: _notificationButtonTextStyle),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.homeRoute,
              )),
              [
                Icon(CupertinoIcons.star,
                    size: _buttonSize, color: Colors.black),
                _gap,
                Text("收藏", style: _notificationButtonTextStyle),
              ],
            ),
          ),
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.homeRoute,
              )),
              [
                CustomStyles.getDefaultUnfilledFollowerIcon(
                    size: _buttonSize, color: Colors.black),
                _gap,
                Text("关注", style: _notificationButtonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
