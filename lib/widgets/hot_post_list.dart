import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/routing_dto/jump_post_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/post_card_image.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_post_list.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HotPostList extends StatefulWidget {
  const HotPostList({Key? key}) : super(key: key);

  @override
  _HotPostListState createState() => _HotPostListState();
}

class _HotPostListState extends State<HotPostList> {
  PagingManager<HotPost> _pagingManager = PagingManager(
    10,
    (page, pageSize) async {
      final response = await PostService.getHotList(page, pageSize);
      List<HotPost> _hotPost =
          (response.data as List).map((e) => HotPost.fromJson(e)).toList();
      return _hotPost;
    },
    (context, item, index) => HotPostCard(item, index + 1),
    firstPageIndicator: SkeletonPostList(),
  );

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

class HotPostCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final HotPost _hotPost;
  final int _rank;
  late final Post _post;

  HotPostCard(this._hotPost, this._rank, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _post = _hotPost._post;

    final userAndContentColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarWithName(_post.hostComment.user.userName,
            _post.hostComment.user.userId, 21.0,
            textStyle: CustomStyles.postContentStyle,
            gap: 7.0,
            avatarUrl: _post.hostComment.user.avatarUrl),
        _gap,
        buildContent(),
      ],
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final userAndContentColumnWithImage = _post.hostComment.imageUrl.isNotEmpty
        ? IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 14,
                  child: userAndContentColumn,
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: PostCardImage(
                        _post.hostComment.imageUrl[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : userAndContentColumn;

    return Card(
      elevation: Constants.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Stack(alignment: Alignment.topCenter, children: [
                Icon(
                  CupertinoIcons.bookmark_solid,
                  size: 27,
                  color: getBookmarkColor(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(_rank.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _rank <= 3 ? Colors.white : Colors.grey)),
                ),
              ]),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(),
                    _gap,
                    userAndContentColumnWithImage,
                    _gap,
                    buildFooter(),
                  ]),
            ),
          ]),
        ),
        onTap: () {
          Navigator.push(
              context,
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.postRoute,
                arguments: JumpPostDTO(_post, pageIndex: 0),
              )));
        },
      ),
    );
  }

  buildTitle() => Text(
        _post.title,
        style: CustomStyles.postTitleStyle,
      );

  buildContent() => _post.hostComment.content.isNotEmpty
      ? Text(
          _post.hostComment.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: CustomStyles.postContentStyle,
        )
      : SizedBox.shrink();

  buildFooter() => RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: CustomStyles.getDefaultHotIcon(),
            ),
            TextSpan(
              text: ' ${_hotPost._hotIndex} · ',
            ),
            WidgetSpan(
              child: CustomStyles.getDefaultReplyIcon(),
            ),
            TextSpan(
              text: ' ${_post.commentCount} · ',
            ),
            WidgetSpan(
                child:
                    _post.hostComment.approvalStatus == ApprovalStatus.approve
                        ? CustomStyles.getDefaultThumbUpIcon()
                        : CustomStyles.getDefaultNotThumbUpIcon()),
            TextSpan(
              text: ' ${_post.approvalCount} · ${_post.hostComment.timeString}',
            ),
            WidgetSpan(
                child: _post.isFrozen
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 130.0),
                          CustomStyles.getFreezeIcon(),
                          Text("该帖子已被锁定", style: CustomStyles.postFrozenStyle)
                        ],
                      )
                    : Container()),
          ],
          style: CustomStyles.postFooterStyle,
        ),
      );

  getBookmarkColor() {
    switch (_rank) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Color.fromRGBO(227, 166, 82, 100);
      default:
        return Colors.transparent;
    }
  }
}

class HotPost {
  Post _post;
  int _hotIndex;

  HotPost.fromJson(Map<String, dynamic> json)
      : _post = Post.fromJson(json['post']),
        _hotIndex = json['hotIndex'];
}
