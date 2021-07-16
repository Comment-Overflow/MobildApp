import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/search_bar.dart';
import 'package:comment_overflow/widgets/searched_post_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchResultPage extends StatelessWidget {
  static const _tabs = ['综合', '用户', '校园生活', '校园生活', '校园生活'];
  final _searchKey;

  const SearchResultPage(this._searchKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      bottom: buildTabBar(),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    MediaQuery.removePadding(
                      context: context,
                      child: SearchedPostCardList(this._searchKey),
                      removeTop: true,
                    ),
                    Text('热榜'),
                    Text('热榜'),
                    Text('热榜'),
                    Text('热榜'),
                  ],
                  physics: new NeverScrollableScrollPhysics(),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  child: SafeArea(
                    top: false,
                    child: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Row(children: [
                        buildBackIcon(context),
                        buildSearchBar(context),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  buildTabBar() => TabBar(
        tabs: _tabs.map((e) => Tab(text: e)).toList(),
        isScrollable: true,
      );

  buildSearchBar(BuildContext context) => Expanded(
        child: SearchBar(
            defaultText: this._searchKey,
            enable: false,
            onTap: () =>
                Navigator.of(context).pushNamed(RouteGenerator.searchRoute)),
      );

  buildBackIcon(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
            RouteGenerator.homeRoute, (route) => false),
        child: CustomStyles.getDefaultBackIcon(context,
            size: Constants.searchBarHeight * 0.8),
      );
}
