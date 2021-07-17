import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
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
  final List<Color> data = List.generate(24, (i) => Color(0xFFFF00FF - 24 * i));

  @override
  void initState() {
    // TODO: Get personalPageInfo using widget.userId
    super.initState();
  }

  String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  Widget _buildColorItem(Color color) => Card(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 60,
          color: color,
          child: Text(
            colorString(color),
            style: const TextStyle(color: Colors.white, shadows: [
              Shadow(color: Colors.black, offset: Offset(.5, .5), blurRadius: 2)
            ]),
          ),
        ),
      );

  Widget _buildSliverList() => SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildColorItem(data[index]),
            childCount: data.length),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _personalPageInfo.userName + "的个人主页",
          style: CustomStyles.pageTitleStyle,
        ),
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
              delegate: PersonalPostHeader(),
            )
          ];
        },
        body: Container(child: PostCardList()),
      ),
    );
  }
}

class PersonalPostHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
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
                style: TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                  borderWidth: 0.8,
                  borderColor: [Colors.grey.withOpacity(0.8)],
                  activeBgColor: [
                    Theme.of(context).accentColor.withOpacity(0.8)
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: Colors.grey,
                  totalSwitches: 2,
                  labels: ['热度', '时间'],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
              ],
            ),
          ),
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
