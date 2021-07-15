import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/utils/route_generator.dart';
import 'package:zhihu_demo/widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: SearchBar(
                  onSearch: (text) {
                    Navigator.of(context).pushNamed(
                        RouteGenerator.searchResultRoute,
                        arguments: text);
                  },
                  autoFocus: true,
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                      padding: EdgeInsets.only(left: 7.0, right: 7.0,),
                      child: Text(
                        "取消",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ))),
            ],
          ),
          automaticallyImplyLeading: false,
          elevation: Constants.defaultAppBarElevation,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "搜索历史",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 18.0,
                  color: Colors.grey[500],
                ),
              )
            ]),
            SizedBox(height: 10.0),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                    return true;
                  },
                  child: StaggeredGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5.0,
                    staggeredTiles: searchHistory
                        .map<StaggeredTile>((_) => StaggeredTile.fit(1))
                        .toList(),
                    children: searchHistory
                        .map((String text) => Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Text(text,
                                maxLines: 1, overflow: TextOverflow.ellipsis)))
                        .toList(),
                  )),
            ),
          ]),
        ));
  }
}
