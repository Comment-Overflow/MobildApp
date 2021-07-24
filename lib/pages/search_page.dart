import 'dart:convert';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/search_bar.dart';
import 'package:comment_overflow/widgets/search_history_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: Constants.defaultAppBarElevation,
          title: Row(
            children: [
              Expanded(
                child: SearchBar(
                  onSearch: (text) {
                    _appendSearchHistory(text);
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
                      padding: EdgeInsets.only(
                        left: 7.0,
                        right: 7.0,
                      ),
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
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: StorageUtil().storage.read(key: Constants.searchHistory),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? SearchHistoryGrid(
                        snapshot.data == null ? [] : jsonDecode(snapshot.data))
                    : Container();
              }),
        ));
  }

  /// Flutter secure storage cannot store array directly, so just store
  /// serialized array.
  void _appendSearchHistory(text) async {
    String? searchHistoryStr =
        await StorageUtil().storage.read(key: Constants.searchHistory);
    List searchHistory =
        searchHistoryStr == null ? [] : jsonDecode(searchHistoryStr);
    if (searchHistory.length == Constants.maxSearchHistory) {
      searchHistory.removeLast();
    }
    searchHistory.insert(0, text);
    StorageUtil()
        .storage
        .write(key: Constants.searchHistory, value: jsonEncode(searchHistory));
  }
}
