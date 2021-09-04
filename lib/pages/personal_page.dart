import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/admin_service.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/service/profile_service.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/adaptive_alert_dialog.dart';
import 'package:comment_overflow/widgets/personal_profile_card.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:comment_overflow/widgets/searched_comment_card_list.dart';
import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
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
  late PersonalPageInfo _personalPageInfo;
  SortPolicy _policy = SortPolicy.hottest;
  late ValueSetter _callback;
  bool _hasInit = false;

  @override
  void initState() {
    _callback = (dynamic json) => this.setState(() {
          _personalPageInfo = PersonalPageInfo.fromJson(json);
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _initData(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: Constants.defaultCardElevation,
            ),
            body: _buildEmptyWidget(),
          );
        }
        bool isSelf = snapshot.data == widget._userId;
        bool isAdmin = StorageUtil().loginInfo.userType == UserType.Admin;
        String title = isSelf ? "我的个人主页" : _personalPageInfo.userName + "的个人主页";
        return Scaffold(
          appBar: AppBar(
            elevation: Constants.defaultAppBarElevation,
            title: Text(
              title,
              style: CustomStyles.pageTitleStyle,
            ),
            actions: [
              isSelf ? _buildSignOutButton() : Container(),
              (isAdmin && !isSelf)
                  ? Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: _buildSilenceUserButton(),
                    )
                  : Container(),
            ],
            leading: widget._fromCard ? _buildBackButton() : null,
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: DefaultTabController(
            length: Constants.personalPageTabs.length,
            child: NestedScrollView(
              physics: NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                        color: Colors.white,
                        child: PersonalProfileCard(_personalPageInfo, isSelf)),
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: isSelf
                        ? TabBarHeader()
                        : PersonalPostHeader(onToggle: _onToggle),
                  ),
                ];
              },
              body: TabBarView(children: [
                Container(
                    child: PostCardList(
                  userId: widget._userId,
                )),
                Container(
                    child: SearchedCommentCardList("", userId: widget._userId)),
                Container(
                    child: PostCardList(
                  userId: widget._userId,
                  isStarred: true,
                )),
              ]),
            ),
          ),
        );
      },
    );
  }

  Future<int> _initData() async {
    if (!_hasInit) {
      await ProfileService.getProfile('/profiles/${widget._userId}', _callback);
      _hasInit = true;
    }
    return GeneralUtils.getCurrentUserId();
  }

  void _onToggle(int index) {
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

  Widget _buildSignOutButton() {
    return IconButton(
      padding: const EdgeInsets.all(7.0),
      icon: CustomStyles.getDefaultSignOutIcon(),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AdaptiveAlertDialog("退出登录", "确定要退出登录吗？", "确定", "取消",
                  _onConfirmLogout, () => Navigator.pop(context));
            });
      },
    );
  }

  Future _onConfirmLogout() async {
    await ChatService.disposeChat();
    await StorageUtil().deleteOnLogout();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteGenerator.loginRoute, (route) => false);
  }

  Widget _buildSilenceUserButton() {
    var iconSize = 26.0;
    bool isLoading = false;

    Future<void> _silenceUser(StateSetter setter) async {
      setter(() {
        isLoading = true;
      });
      try {
        await AdminService.silenceUser(widget._userId);
        setter(() {
          _personalPageInfo.userType = UserType.Silenced;
          isLoading = false;
        });
      } on DioError catch (e) {
        MessageBox.showToast(
            msg: e.response!.data, messageBoxType: MessageBoxType.Error);
        setter(() {
          isLoading = false;
        });
      }
    }

    Future<void> _freeUser(StateSetter setter) async {
      setter(() {
        isLoading = true;
      });
      try {
        await AdminService.freeUser(widget._userId);
        setter(() {
          _personalPageInfo.userType = UserType.User;
          isLoading = false;
        });
      } on DioError catch (e) {
        MessageBox.showToast(
            msg: e.message, messageBoxType: MessageBoxType.Error);
        setter(() {
          isLoading = false;
        });
      }
    }

    return StatefulBuilder(builder: (bc, s) {
      if (isLoading) return CupertinoActivityIndicator();

      silenceCallback() {
        _silenceUser(s);
        Navigator.pop(context);
      }

      freeCallback() {
        _freeUser(s);
        Navigator.pop(context);
      }

      cancelCallback() {
        Navigator.pop(context);
      }

      switch (_personalPageInfo.userType) {
        case UserType.User:
          {
            return IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AdaptiveAlertDialog(
                            "禁言用户",
                            "你确认要禁言用户 ${_personalPageInfo.userName} 吗",
                            "确定",
                            "取消",
                            silenceCallback,
                            cancelCallback);
                      });
                },
                icon: CustomStyles.getSilenceIcon(size: iconSize));
          }
        case UserType.Silenced:
        case UserType.Banned:
          {
            return IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AdaptiveAlertDialog(
                            "解禁用户",
                            "你确认要解禁用户 ${_personalPageInfo.userName} 吗",
                            "确定",
                            "取消",
                            freeCallback,
                            cancelCallback);
                      });
                },
                icon: CustomStyles.getFreeIcon(size: iconSize));
          }
        case UserType.Admin:
          {
            return IconButton(
                onPressed: () {}, icon: CustomStyles.getAdminIcon());
          }
        default:
          return Container();
      }
    });
  }

  _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: CustomStyles.getDefaultBackIcon(size: 24.0, color: Colors.black),
    );
  }

  Widget _buildEmptyWidget() => Center(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: EmptyWidget(
            image: null,
            packageImage: PackageImage.Image_2,
          ),
        ),
      );
}

class TabBarHeader extends SliverPersistentHeaderDelegate {
  TabBarHeader()
      : _tabBar = TabBar(
          tabs: Constants.personalPageTabs.map((e) => Tab(text: e)).toList(),
          isScrollable: false,
        );

  final TabBar _tabBar;

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
              minHeight: 25.0,
              cornerRadius: 20.0,
              fontSize: 12.0,
              borderWidth: 0.5,
              borderColor: [Theme.of(context).accentColor],
              activeBgColor: [Theme.of(context).buttonColor],
              activeFgColor: Theme.of(context).accentColor,
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.grey,
              totalSwitches: 2,
              labels: ['热度', '时间'],
              onToggle: _onToggle,
              radiusStyle: true,
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
