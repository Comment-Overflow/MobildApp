import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_colors.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/utils/route_generator.dart';
import 'package:zhihu_demo/widgets/post_card_list.dart';
import 'package:zhihu_demo/widgets/quote_card.dart';
import 'package:zhihu_demo/widgets/search_bar.dart';


class HomePage extends StatelessWidget {

  static const _tabs = ['浏览', '推荐', '关注'];

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
              tabs: _tabs.map((e) => Tab(text: e,)).toList(),
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
      )
    );
  }
}

