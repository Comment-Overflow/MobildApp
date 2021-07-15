import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/utils/route_generator.dart';
import 'package:zhihu_demo/widgets/search_bar.dart';
import 'package:zhihu_demo/widgets/searched_post_card_list.dart';

class SearchResultPage extends StatelessWidget {
  final _searchKey;

  const SearchResultPage(this._searchKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: Constants.defaultAppBarElevation,
          automaticallyImplyLeading: false,
          title: Row(children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteGenerator.homeRoute, (route) => false),
              child: Icon(
                Icons.arrow_back_ios,
                size: Constants.searchBarHeight * 0.8,
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: SearchBar(
                  defaultText: this._searchKey,
                  enable: false,
                  onTap: () => Navigator.of(context)
                      .pushNamed(RouteGenerator.searchRoute)),
            ),
          ])),
      body: SearchedPostCardList(this._searchKey),
    );
  }
}
