import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/search_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/user_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class SearchedUserCardList extends StatefulWidget {
  final _searchKey;

  const SearchedUserCardList(this._searchKey, {Key? key}) : super(key: key);

  @override
  _SearchedUserCardListState createState() =>
      _SearchedUserCardListState(_searchKey);
}

class _SearchedUserCardListState extends State<SearchedUserCardList> {
  final PagingManager<UserCardInfo> _pagingManager;

  _SearchedUserCardListState(searchKey)
      : _pagingManager =
            PagingManager(Constants.defaultPageSize, (page, pageSize) async {
          final Response response =
              await SearchService.searchUser(searchKey, page, pageSize);

          return (response.data as List)
              .map((e) => UserCardInfo.fromJson(e))
              .toList();
        }, (context, item, index) => UserCard(item, searchKey: searchKey));

  @override
  dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView(refreshable: false);
  }
}
