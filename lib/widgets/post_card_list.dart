import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletons/skeletons.dart';

class PostCardList extends StatefulWidget {
  final PostTag? _tag;
  final int? _userId;
  final bool _isStarred;
  const PostCardList(
      {PostTag? tag, int? userId, bool isStarred = false, Key? key})
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
    var response = widget._userId == null
        ? (await PostService.getPosts(
            PostQueryDTO(tag: widget._tag, pageNum: page, pageSize: pageSize)))
        : widget._isStarred == true
            ? (await PostService.getStarredPosts(
                PostQueryDTO(pageNum: page, pageSize: pageSize)))
            : (await PostService.getMyPosts(widget._userId.toString(),
                PostQueryDTO(pageNum: page, pageSize: pageSize)));

    var postObjJson = response.data['content'] as List;
    return postObjJson.map((e) => Post.fromJson(e)).toList();
  }, (context, item, index) => PostCard(item),
          emptyIndicatorTitle: Constants.browsePostIndicatorTitle,
          emptyIndicatorSubtitle: Constants.browsePostEmptyIndicatorSubtitle,
          firstPageIndicator: _SkeletonList());

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

class _SkeletonList extends StatelessWidget {
  static const _gap = const SizedBox(height: 20.0);
  static const _line = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 11.0,
  ));
  static const _block = SkeletonLine(
    style: SkeletonLineStyle(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      height: 80,
    ),
  );
  static final _card = SizedBox(
    height: 128,
    child: Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SkeletonItem(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      _line,
                      _gap,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _line,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: _block,
                ),
              ],
            ),
          ),
        )),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.filled(6, _card),
    );
  }
}
