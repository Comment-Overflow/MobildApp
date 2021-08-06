import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/following_comment_list.dart';
import 'package:comment_overflow/widgets/hot_post_list.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:comment_overflow/widgets/recommend_post_list.dart';
import 'package:comment_overflow/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final _tabs = ['时间线', '热榜', '推荐', '关注'] + Constants.postCategories;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: SafeArea(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) => [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                elevation: Constants.defaultAppBarElevation,
                title: Row(
                  children: [
                    buildSearchBar(context),
                    SizedBox(width: 15.0),
                    buildAddButton(context),
                  ],
                ),
                bottom: _buildTabBar(context),
              ),
            ],
            body: TabBarView(
              children: [
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: HotPostList(),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: RecommendPostList(),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: FollowingCommentList(),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(tag: PostTag.Life),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(tag: PostTag.Study),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(tag: PostTag.Art),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(tag: PostTag.Mood),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(tag: PostTag.Career),
                  removeTop: true,
                ),
              ],
            ),
          ),
        ));
  }

  buildSearchBar(BuildContext context) => Expanded(
        child: SearchBar(
          enable: false,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteGenerator.searchRoute),
        ),
      );

  buildAddButton(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Constants.searchBarHeight * 0.95,
          height: Constants.searchBarHeight * 0.95,
        ),
        child: ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteGenerator.newPostRoute),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).accentColor,
            shape: CircleBorder(),
            padding: EdgeInsets.zero,
          ),
          child: Icon(Icons.add_outlined),
        ),
      );

  _buildTabBar(BuildContext context) {
    final TabBar _tabBar = TabBar(
      tabs: _tabs
          .map((e) => Tab(
                text: e,
              ))
          .toList(),
      isScrollable: true,
    );

    final _realTabBar = Theme(
      data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: _tabBar,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(_tabBar.preferredSize.height),
      child: Row(children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              _realTabBar,
              Container(
                  height: _tabBar.preferredSize.height,
                  width: 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white,
                    ],
                  ))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
              width: Constants.searchBarHeight * 0.95,
              child: IconButton(
                padding: EdgeInsets.zero,
                splashColor: Theme.of(context).buttonColor,
                splashRadius: Constants.searchBarHeight * 0.48,
                icon: Icon(Icons.equalizer, color: Colors.grey),
                onPressed: () => Navigator.of(context)
                    .pushNamed(RouteGenerator.statisticRoute),
              )),
        ),
      ]),
    );
  }
}
