import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:comment_overflow/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  final _tabs = ['时间线', '推荐', '关注'] + Constants.postCategories;

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
                pinned: true,
                floating: true,
                elevation: Constants.defaultAppBarElevation,
                title: Row(
                  children: [
                    buildSearchBar(context),
                    SizedBox(width: 15.0),
                    buildAddButton(context),
                  ],
                ),
                bottom: buildTabBar(),
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
                  child: PostCardList(),
                  removeTop: true,
                ),
                MediaQuery.removePadding(
                  context: context,
                  child: PostCardList(),
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

  buildTabBar() => TabBar(
        tabs: _tabs
            .map((e) => Tab(
                  text: e,
                ))
            .toList(),
        isScrollable: true,
      );

  buildAddButton(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Constants.searchBarHeight,
          height: Constants.searchBarHeight,
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
}
