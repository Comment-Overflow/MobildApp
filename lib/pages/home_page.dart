import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:comment_overflow/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  static const _tabs = ['浏览', '推荐', '关注', '校园生活', '校园生活', '校园生活'];

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, value) => [
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0.5,
              title: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      enable: false,
                      onTap: () => Navigator.of(context)
                          .pushNamed(RouteGenerator.searchRoute),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: Constants.searchBarHeight,
                      height: Constants.searchBarHeight,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.add_outlined),
                    ),
                  ),
                ],
              ),
              bottom: TabBar(
                tabs: _tabs
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList(),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              MediaQuery.removePadding(
                context: context,
                child: PostCardList(),
                removeTop: true,
              ),
              QuoteCard(quotes[0]),
              Text('热榜'),
            ],
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
