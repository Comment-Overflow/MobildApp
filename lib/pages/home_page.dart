import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fsearch/fsearch.dart';
import 'package:zhihu_demo/assets/custom_colors.dart';
import 'package:zhihu_demo/widgets/post_card_list.dart';


class HomePage extends StatelessWidget {

  static const _tabs = ['浏览', '推荐', '关注'];
  static const _searchbarHeight = 30.0;

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      // child: Scaffold(
      //   appBar: AppBar(
      //     elevation: 0.5,
      //     title: Row(
      //       children: [
      //         Expanded(
      //           child: FSearch(
      //             height: _searchbarHeight,
      //             cursorWidth: 1.0,
      //             corner: FSearchCorner.all(18.0),
      //             backgroundColor: CustomColors.lightGrey,
      //             style: TextStyle(
      //                 fontSize: 16.0, height: 1.2, color: Color(0xff333333)),
      //             margin: EdgeInsets.only(left: 6.0),
      //             prefixes: [
      //               const SizedBox(width: 10.0),
      //               Icon(
      //                 Icons.search,
      //                 size: 20,
      //                 color: Colors.grey[400],
      //               ),
      //               const SizedBox(width: 3.0)
      //             ],
      //             hints: [
      //               "搜索..."
      //             ],
      //             onTap: () => {},
      //           ),
      //         ),
      //         SizedBox(width: 15.0),
      //         ConstrainedBox(
      //           constraints: BoxConstraints.tightFor(
      //               width: _searchbarHeight,
      //               height: _searchbarHeight
      //           ),
      //           child: ElevatedButton(
      //             onPressed: () {},
      //             style: ElevatedButton.styleFrom(
      //               primary: Theme.of(context).accentColor,
      //               shape: CircleBorder(),
      //               padding: EdgeInsets.zero,
      //             ),
      //             child: Icon(Icons.add_outlined),
      //           ),
      //         ),
      //       ],
      //     ),
      //     bottom: TabBar(
      //       tabs: _tabs.map((e) => Tab(text: e,)).toList(),
      //     ),
      //   ),
      //   body: TabBarView(
      //     children: [
      //       PostCardList(),
      //       Text('推荐'),
      //       Text('热榜'),
      //     ],
      //   ),
      // ),
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
                  child: FSearch(
                    height: _searchbarHeight,
                    cursorWidth: 1.0,
                    corner: FSearchCorner.all(18.0),
                    backgroundColor: CustomColors.lightGrey,
                    style: TextStyle(
                        fontSize: 16.0, height: 1.2, color: Color(0xff333333)),
                    margin: EdgeInsets.only(left: 6.0),
                    prefixes: [
                      const SizedBox(width: 10.0),
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 3.0)
                    ],
                    hints: [
                      "搜索..."
                    ],
                    onTap: () => {},
                  ),
                ),
                SizedBox(width: 15.0),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: _searchbarHeight,
                      height: _searchbarHeight
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
            Text('推荐'),
            Text('热榜'),
          ],
        ),
      )
    );
  }
}

