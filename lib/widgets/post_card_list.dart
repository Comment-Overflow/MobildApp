import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostCardList extends StatefulWidget {
  final PostTag? _tag;
  final int? _userId;
  final bool _isStarred;
  const PostCardList({PostTag? tag, int? userId, bool isStarred = false, Key? key})
      : _tag = tag,
        _userId = userId,
        _isStarred = isStarred,
        super(key: key);

  @override
  _PostCardListState createState() => _PostCardListState();
}

class _PostCardListState extends State<PostCardList> {
  late final PagingManager<Post> _pagingManager =
      PagingManager(Constants.defaultPageSize, (page, pageSize) async {
    var response = widget._userId == null ?
        (await PostService.getPosts(PostQueryDTO(tag: widget._tag, pageNum: page, pageSize: pageSize)))
        : widget._isStarred == true ? (await PostService.getStarredPosts(PostQueryDTO(pageNum: page, pageSize: pageSize)))
        : (await PostService.getMyPosts(widget._userId.toString(), PostQueryDTO(pageNum: page, pageSize: pageSize)));
    var postObjJson = response.data['content'] as List;
    return postObjJson.map((e) => Post.fromJson(e)).toList();
  }, (context, item, index) => PostCard(item),
          emptyIndicatorTitle: Constants.browsePostIndicatorTitle,
          emptyIndicatorSubtitle: Constants.browsePostEmptyIndicatorSubtitle);

  @override
  dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView();
  }
}
