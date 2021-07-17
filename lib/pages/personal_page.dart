import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/multi_widget_button.dart';
import 'package:comment_overflow/widgets/personal_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {

  final int userId;
  final Widget _gap = const SizedBox(height: 2);

  const PersonalPage(this.userId, {Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalPageInfo _personalPageInfo = personalPageInfo;

  @override
  void initState() {
    // TODO: Get personalPageInfo using widget.userId
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "个人主页",
          style: CustomStyles.pageTitleStyle,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PersonalHeader(_personalPageInfo),
          Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 15, child: Container()),
                Expanded(
                  flex: 35,
                  child: MultiWidgetButton(
                    RouteGenerator.generateRoute(RouteSettings(
                      // TODO: following page route
                      name: RouteGenerator.homeRoute,
                    )),
                    [
                      Text(
                        _personalPageInfo.followingCount.toString(),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      widget._gap,
                      Text(
                        '关注',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 35,
                  child: MultiWidgetButton(
                    RouteGenerator.generateRoute(RouteSettings(
                      // TODO: follower page route
                      name: RouteGenerator.homeRoute,
                    )),
                    [
                      Text(
                        _personalPageInfo.followerCount.toString(),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      widget._gap,
                      Text(
                        '粉丝',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 15, child: Container()),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
