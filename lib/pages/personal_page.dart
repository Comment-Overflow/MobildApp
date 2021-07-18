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
  final int _userId;
  final bool _fromCard;

  const PersonalPage(this._userId, this._fromCard, {Key? key})
      : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalPageInfo _personalPageInfo = personalPageInfo;
  bool _isSelf = false;
  SortPolicy _policy = SortPolicy.hottest;

  @override
  void initState() {
    // TODO: Get personalPageInfo using widget.userId
    super.initState();
    // _isSelf = false;
    _isSelf = widget._userId == currentUserId;
    print(_isSelf);
  }

  @override
  Widget build(BuildContext context) {
    String title = _isSelf ? "我的个人主页" : _personalPageInfo.userName + "的个人主页";

    return Scaffold(
      appBar: AppBar(
        elevation: Constants.defaultAppBarElevation,
        title: Text(
          title,
          style: CustomStyles.pageTitleStyle,
        ),
        actions: [_isSelf ? _buildDropDownMenu() : Container()],
        automaticallyImplyLeading: widget._fromCard,
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
                    color: Colors.white,
                    child: PersonalProfileCard(_personalPageInfo, _isSelf)),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: _isSelf
                    ? TabBarHeader()
                    : PersonalPostHeader(onToggle: _onToggle),
              ),
            ];
          },
          body: Container(child: PostCardList()),
        ),
      ),
      bottomNavigationBar:
          _isSelf ? SafeArea(child: _buildSorter()) : Container(height: 0),
    );
  }

  void _onToggle(int index) {
    // TODO: Implement onToggle.
    switch (index) {
      case 0:
        setState(() {
          _policy = SortPolicy.hottest;
        });
        break;
      case 1:
        setState(() {
          _policy = SortPolicy.latest;
        });
        break;
    }
  }

  void _onSort(SortPolicy policy) {
    setState(() {
      _policy = policy;
    });
  }

  Widget _buildSorter() {
    return Container(
      height: 32.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupMenuButton<SortPolicy>(
              onSelected: _onSort,
              child: Row(
                children: [
                  CustomStyles.getDefaultListIcon(),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      Constants.sorterTexts[_policy.index],
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: SortPolicy.hottest,
                  child: Text(Constants.sorterTexts[SortPolicy.hottest.index]),
                ),
                PopupMenuItem(
                  value: SortPolicy.latest,
                  child: Text(Constants.sorterTexts[SortPolicy.latest.index]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropDownMenu() {
    return PopupMenuButton<Setting>(
      padding: const EdgeInsets.all(7.0),
      onSelected: (Setting setting) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RouteGenerator.loginRoute, (route) => false);
      },
      itemBuilder: (BuildContext context) => [
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

class TabBarHeader extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar = TabBar(
    tabs: Constants.personalPageTabs.map((e) => Tab(text: e)).toList(),
    isScrollable: false,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class PersonalPostHeader extends SliverPersistentHeaderDelegate {
  final void Function(int)? _onToggle;

  const PersonalPostHeader({onToggle, onSelect}) : _onToggle = onToggle;

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
              activeBgColor: [Theme.of(context).accentColor.withOpacity(0.9)],
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

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
          vertical: Constants.defaultPersonalPageVerticalPadding * 0.7),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "帖子",
                  // shrinkOffset.toString(),
                  style: TextStyle(
                    fontSize: 19.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildToggle(context),
        ],
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
