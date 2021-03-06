import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/routing_dto/jump_post_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/post_card_image.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:substring_highlight/substring_highlight.dart';

class PostCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final Post _post;

  const PostCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    aspectRatio: 1.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: PostCardImage(
                        _post.hostComment.imageUrl[0],
                        fit: BoxFit.cover,
                        cache: true,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildTitle(),
            _gap,
            userAndContentColumnWithImage,
            _gap,
            buildFooter(),
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

  buildFooter() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: CustomStyles.getDefaultReplyIcon(),
                ),
                TextSpan(
                  text: ' ${_post.commentCount} ?? ',
                ),
                WidgetSpan(
                    child: _post.hostComment.approvalStatus ==
                            ApprovalStatus.approve
                        ? CustomStyles.getDefaultThumbUpIcon()
                        : CustomStyles.getDefaultNotThumbUpIcon()),
                TextSpan(
                  text:
                      ' ${_post.approvalCount} ?? ${GeneralUtils.getDefaultTimeString(_post.lastCommentTime)}',
                ),
              ],
              style: CustomStyles.postFooterStyle,
            ),
          ),
          _post.isFrozen
              ? Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomStyles.getFreezeIcon(),
                      AutoSizeText(Constants.postFrozenPrompt,
                          style: CustomStyles.postFrozenStyle, maxLines: 1)
                    ],
                  ),
                )
              : Container(),
        ],
      );
}

class SearchedCommentCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final SearchedPost _post;
  final List<String> searchKey;

  const SearchedCommentCard(this._post, this.searchKey, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Comment _searchedComment = _post.searchedComment;
    UserInfo _user = _searchedComment.user;

    final userAndContentColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarWithName(_user.userName, _user.userId, 21.0,
            textStyle: CustomStyles.postContentStyle,
            gap: 7.0,
            avatarUrl: _user.avatarUrl),
        _gap,
        buildContent(),
      ],
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final userAndContentColumnWithImage = _searchedComment.imageUrl.isNotEmpty
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
                        _searchedComment.imageUrl[0],
                        fit: BoxFit.cover,
                        cache: true,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildTitle(),
            _gap,
            userAndContentColumnWithImage,
            _gap,
            buildFooter(),
          ]),
        ),
        onTap: () {
          Navigator.push(
              context,
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.postRoute,
                arguments:
                    JumpPostDTO(_post, pageIndex: _searchedComment.floor),
              )));
        },
      ),
    );
  }

  buildTitle() => SubstringHighlight(
        text: _post.title,
        terms: searchKey,
        textStyle: CustomStyles.postTitleStyle,
        textStyleHighlight: CustomStyles.highlightedPostTitleStyle,
      );

  buildContent() => _post.searchedComment.content.isNotEmpty
      ? SubstringHighlight(
          text: _post.searchedComment.content,
          terms: searchKey,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textStyle: CustomStyles.postContentStyle,
          textStyleHighlight: CustomStyles.highlightedPostContentStyle,
        )
      : SizedBox.shrink();

  buildFooter() => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _post.searchedComment.floor == 0
                  ? '?????? ?? '
                  : '${_post.searchedComment.floorString}??? ?? ',
            ),
            WidgetSpan(
              child:
                  _post.searchedComment.approvalStatus == ApprovalStatus.approve
                      ? CustomStyles.getDefaultThumbUpIcon()
                      : CustomStyles.getDefaultNotThumbUpIcon(),
            ),
            TextSpan(
              text:
                  ' ${_post.searchedComment.approvalCount} ?? ${_post.searchedComment.timeString}',
            ),
          ],
          style: CustomStyles.postFooterStyle,
        ),
      );
}

/// SearchedCommentCard with no highlighting and search key.
class CommentSummaryCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final SearchedPost _post;

  const CommentSummaryCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Comment _comment = _post.searchedComment;
    UserInfo _user = _comment.user;

    final userAndContentColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarWithName(_user.userName, _user.userId, 21.0,
            textStyle: CustomStyles.postContentStyle,
            gap: 7.0,
            avatarUrl: _user.avatarUrl),
        _gap,
        buildContent(),
      ],
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final userAndContentColumnWithImage = _comment.imageUrl.isNotEmpty
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
                        _comment.imageUrl[0],
                        fit: BoxFit.cover,
                        cache: true,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildTitle(),
            _gap,
            userAndContentColumnWithImage,
            _gap,
            buildFooter(),
          ]),
        ),
        onTap: () {
          Navigator.push(
              context,
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.postRoute,
                arguments: JumpPostDTO(_post, pageIndex: _comment.floor),
              )));
        },
      ),
    );
  }

  buildTitle() => Text(
        _post.title,
        style: CustomStyles.postTitleStyle,
      );

  buildContent() => _post.searchedComment.content.isNotEmpty
      ? Text(
          _post.searchedComment.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: CustomStyles.postContentStyle,
        )
      : SizedBox.shrink();

  buildFooter() => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _post.searchedComment.floor == 0
                  ? '?????? ?? '
                  : '${_post.searchedComment.floorString}??? ?? ',
            ),
            WidgetSpan(
              child:
                  _post.searchedComment.approvalStatus == ApprovalStatus.approve
                      ? CustomStyles.getDefaultThumbUpIcon()
                      : CustomStyles.getDefaultNotThumbUpIcon(),
            ),
            TextSpan(
              text:
                  ' ${_post.searchedComment.approvalCount} ?? ${_post.searchedComment.timeString}',
            ),
          ],
          style: CustomStyles.postFooterStyle,
        ),
      );
}
