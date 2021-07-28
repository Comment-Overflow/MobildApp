import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/pages/home_page.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/multiple_widget_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class NotificationButtonList extends StatefulWidget {
  final _buttonSize;

  NotificationButtonList(this._buttonSize, {Key? key}) : super(key: key);

  @override
  _NotificationButtonList createState() => _NotificationButtonList();
}

class _NotificationButtonList extends State<NotificationButtonList> {
  bool _haveNewApprovals = false;
  bool _haveNewReplies = false;
  bool _haveNewStars = false;
  bool _haveNewFollowers = false;

  @override
  void initState() {
    ValueSetter callback = (dynamic json) => this.setState(() {
      _haveNewApprovals = json['isNewlyApproved'] as bool;
      _haveNewFollowers = json['isNewlyFollowed'] as bool;
      _haveNewStars = json['isNewlyStarred'] as bool;
      _haveNewReplies = json['isNewlyReplied'] as bool;
    });
    NotificationService.ifHaveNewNotification('/notifications/new_records', callback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _notificationButtonTextStyle = TextStyle(
      fontSize: widget._buttonSize * 0.47,
      fontWeight: FontWeight.w400,
      color: Colors.grey[800],
    );
    SizedBox _gap = SizedBox(height: widget._buttonSize * 0.3);

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
              RouteGenerator.approveMeRoute,
                () => this.setState(() {
                _haveNewApprovals = false;
              }),
              [
                Badge(
                  child: Icon(CupertinoIcons.heart,
                      size: widget._buttonSize, color: Colors.black),
                  showBadge: _haveNewApprovals,
                ),
                _gap,
                Text("赞同", style: _notificationButtonTextStyle),
              ],
            ),
          ),
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.replyMeRoute,
                  () => this.setState(() {
                    _haveNewReplies = false;
                  }),
              [
                Badge(
                  child: Icon(CupertinoIcons.text_bubble,
                      size: widget._buttonSize, color: Colors.black),
                  showBadge: _haveNewReplies,
                ),
                _gap,
                Text("回复", style: _notificationButtonTextStyle),
              ],
            ),
          ),
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.starMeRoute,
                  () => this.setState(() {
                    _haveNewStars = false;
                  }),
              [
                Badge(
                  child: Icon(CupertinoIcons.star,
                      size: widget._buttonSize, color: Colors.black),
                  showBadge: _haveNewStars,
                ),
                _gap,
                Text("收藏", style: _notificationButtonTextStyle),
              ],
            ),
          ),
          Expanded(
            flex: 25,
            child: MultipleWidgetButton(
              RouteGenerator.followMeNotificationRoute,
                  () => this.setState(() {
                    _haveNewFollowers = false;
                  }),
              [
                Badge(
                  child: CustomStyles.getDefaultUnfilledFollowerIcon(
                      size: widget._buttonSize, color: Colors.black),
                  showBadge: _haveNewFollowers,
                ),
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
