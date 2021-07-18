import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/personal_profile_card.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PersonalPage extends StatefulWidget {
  final int userId;

  const PersonalPage(this.userId, {Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalPageInfo _personalPageInfo = personalPageInfo;
  bool _isSelf = false;

  @override
  void initState() {
    // TODO: Get personalPageInfo using widget.userId
    super.initState();
    _isSelf = _personalPageInfo.userId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    String title = _isSelf ? "我的个人主页" : _personalPageInfo.userName + "的个人主页";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: CustomStyles.pageTitleStyle,
        ),
        actions: [
          _isSelf
              ? _buildDropDownMenu()
              : IconButton(
                  icon: CustomStyles.getDefaultMailIcon(),
                  onPressed: () {
                    // TODO: add edit page route
                  })
        ],
        automaticallyImplyLeading: false,
      ),
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              floating: false,
              collapsedHeight: Constants.defaultPersonalProfileHeight,
              expandedHeight: Constants.defaultPersonalProfileHeight,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: PersonalProfileCard(_personalPageInfo),
            ),
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: _isSelf
                  ? PersonalPostHeader(onSelect: _onSelect)
                  : PersonalPostHeader(onToggle: _onToggle),
            )
          ];
        },
        body: Container(child: PostCardList()),
      ),
    );
  }

  void _onToggle(int index) {}

  void _onSelect(int index) {}

  Widget _buildDropDownMenu() {
    return PopupMenuButton<Setting>(
      padding: const EdgeInsets.all(7.0),
      onSelected: (Setting setting) {
        switch (setting.index) {
          case 0:
            Navigator.of(context).pushNamed(RouteGenerator.profileSettingRoute);
            break;
          case 1:
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteGenerator.loginRoute, (route) => false);
            break;
        }
        // TODO: edit route and sign out.
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: Setting.editInfo,
          child: Row(
            children: [
              CustomStyles.getDefaultEditIcon(),
              SizedBox(width: 10.0),
              Text("编辑个人资料"),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: Setting.signOut,
          child: Row(
            children: [
              CustomStyles.getDefaultSignOutIcon(),
              SizedBox(width: 10.0),
              Text("退出登录"),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonalPostHeader extends SliverPersistentHeaderDelegate {
  final void Function(int)? _onToggle;
  final void Function(int)? _onSelect;

  const PersonalPostHeader({onToggle, onSelect})
      : _onToggle = onToggle,
        _onSelect = onSelect;

  Widget _buildToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ToggleSwitch(
              minWidth: 50.0,
              minHeight: 20.0,
              cornerRadius: 20.0,
              fontSize: 12.0,
              borderWidth: 0.5,
              borderColor: [Colors.grey.withOpacity(0.8)],
              activeBgColor: [Theme.of(context).accentColor.withOpacity(0.8)],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.grey,
              totalSwitches: 2,
              labels: ['热度', '时间'],
              onToggle: _onToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupMenuButton<int>(
              onSelected: _onSelect,
              child: Row(
                children: [
                  Text(
                    "查看全部",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  CustomStyles.getDefaultRightArrow(),
                ],
              ),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      // CustomStyles.getDefaultEditIcon(),
                      // SizedBox(width: 10.0),
                      Text("查看帖子"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      // CustomStyles.getDefaultSignOutIcon(),
                      // SizedBox(width: 10.0),
                      Text("查看回复"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(
            vertical: Constants.defaultPersonalPageVerticalPadding * 0.7),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "帖子",
                  // shrinkOffset.toString(),
                  style: TextStyle(
                    fontSize: 22.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _onToggle == null ? _buildSelector() : _buildToggle(context),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 42.0;

  @override
  double get minExtent => 42.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
