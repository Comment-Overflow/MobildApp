import 'dart:math';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/service/search_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class SearchedPostCardList extends StatefulWidget {
  final String _searchKey;
  final PostTag? _postTag;

  const SearchedPostCardList(this._searchKey, {Key? key, postTag})
      : _postTag = postTag,
        super(key: key);

  @override
  _SearchedPostCardListState createState() =>
      _SearchedPostCardListState(_searchKey);
}

class _SearchedPostCardListState extends State<SearchedPostCardList> {
  final PagingManager<Post> _pagingManager;

  _SearchedPostCardListState(_searchKey)
      : _pagingManager =
            PagingManager(Constants.defaultPageSize, (page, pageSize) async {
          final Response response =
              await SearchService.searchComment(_searchKey, page, pageSize);
          print(response.data);
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
