import 'package:comment_overflow/widgets/approval_button.dart';
import 'package:comment_overflow/widgets/disapproval_button.dart';
import 'package:comment_overflow/widgets/image_list.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:flutter/material.dart';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';
import 'package:flutter/widgets.dart';

class CommentCard extends StatefulWidget {
  final Comment _comment;
  final String _title;

  const CommentCard(this._comment, {Key? key, title = ""})
      : _title = title,
        super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static const _gap = const SizedBox(height: 10.0);
  static const _iconSize = 17.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
              left: Constants.defaultCardPadding,
              right: Constants.defaultCardPadding,
              top: Constants.defaultCardPadding,
              bottom: widget._comment.floor == 0
                  ? Constants.defaultCardPadding
                  : Constants.defaultCardPadding / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...(widget._comment.floor == 0 && widget._title.isNotEmpty
                  ? [_buildTitle(), _gap]
                  : [SizedBox.shrink()]),
              Row(
                children: [
                  Expanded(
                    child: UserAvatarWithName(
                      widget._comment.user.userName,
                      Constants.defaultAvatarInCommentSize,
                      image: NetworkImage(widget._comment.user.avatarUrl),
                    ),
                  ),
                  Text(
                    widget._comment.timeString,
                    style: CustomStyles.dateStyle,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget._comment.floor > 0
                        ? widget._comment.floorString + '楼'
                        : "",
                    style: CustomStyles.floorStyle,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              _gap,
              widget._comment.quote == null
                  ? SizedBox.shrink()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _gap,
                        Expanded(child: QuoteCard(widget._comment.quote)),
                      ],
                    ),
              _gap,
              Text(
                widget._comment.content,
              ),
              _gap,
              ImageList(widget._comment.imageUrl),
              widget._comment.floor > 0
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ApprovalButton.horizontal(
                          comment: widget._comment,
                          userId: 1,
                          size: _iconSize,
                        ),
                        DisapprovalButton(
                          comment: widget._comment,
                          userId: 1,
                          size: _iconSize,
                          showText: false,
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          icon:
                              CustomStyles.getDefaultReplyIcon(size: _iconSize),
                          onPressed: _pushReply,
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          icon: CustomStyles.getDefaultDeleteIcon(
                              size: _iconSize),
                          onPressed: () => {},
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() => Padding(
        padding: const EdgeInsets.only(
          top: Constants.defaultCardPadding / 2,
          bottom: Constants.defaultCardPadding / 3,
        ),
        child: Text(
          widget._title,
          style: CustomStyles.postPageTitleStyle,
        ),
      );

  void _pushReply() {}
}
