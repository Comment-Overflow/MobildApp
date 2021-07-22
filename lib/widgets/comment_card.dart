import 'package:comment_overflow/assets/custom_colors.dart';
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
  final bool _highlight;

  const CommentCard(this._comment, {Key? key, title = "", highlight = false})
      : _title = title,
        _highlight = highlight,
        super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard>
    with SingleTickerProviderStateMixin {
  static const _gap = const SizedBox(height: 10.0);
  static const _iconSize = 17.0;

  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: Constants.defaultHighlightTime));
    _colorTween =
        ColorTween(begin: Colors.white, end: CustomColors.highlightBlue)
            .animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._highlight) _highlightComment();
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Card(
        color: _colorTween.value,
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: InkWell(
          onTap: () {},
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
                        image: widget._comment.user.avatarUrl == null ? null : NetworkImage(widget._comment.user.avatarUrl!),
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
                            icon: CustomStyles.getDefaultReplyIcon(
                                size: _iconSize),
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
      ),
    );
  }

  Future _highlightComment() async {
    await _animationController.forward();
    await _animationController.reverse();
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
