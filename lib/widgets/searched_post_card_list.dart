import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:flutter/widgets.dart';

class SearchedPostCardList extends StatefulWidget {
  final _searchKey;

  const SearchedPostCardList(this._searchKey, {Key? key}) : super(key: key);

  @override
  _SearchedPostCardListState createState() => _SearchedPostCardListState();
}

class _SearchedPostCardListState extends State<SearchedPostCardList> {
  final PagingManager<Post> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => posts.sublist(
          page * pageSize, min((page + 1) * pageSize, posts.length)),
    );
  }, (context, item, index) => PostCard(item));

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
