import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/user_card.dart';
import 'package:flutter/widgets.dart';

class SearchedUserCardList extends StatefulWidget {
  final _searchKey;

  const SearchedUserCardList(this._searchKey, {Key? key}) : super(key: key);

  @override
  _SearchedUserCardListState createState() => _SearchedUserCardListState();
}

class _SearchedUserCardListState extends State<SearchedUserCardList> {
  final PagingManager<UserCardInfo> _pagingManager =
  PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
          () => users.sublist(
          page * pageSize, min((page + 1) * pageSize, users.length)),
    );
  }, (context, item, index) => UserCard(item));

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
