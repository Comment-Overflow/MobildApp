import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:flutter/material.dart';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';

class CommentCard extends StatefulWidget {
  final Comment _comment;
  final String _title;

  const CommentCard(this._comment, {Key? key, title = ""})
      : _title = title, super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static const _gap = const SizedBox(height: 5.0);
  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget._comment.floor == 0 && widget._title.isNotEmpty
                ? _buildTitle()
                : SizedBox.shrink(),
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
                      ? widget._comment.floorString + "楼"
                      : "",
                    style: CustomStyles.floorStyle,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
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
              _buildImageList(),
              widget._comment.floor > 0
                ? Column(
                children: [
                  _gap,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: CustomStyles.getDefaultDeleteIcon(size: _iconSize),
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: widget._comment.approvalStatus == ApprovalStatus.approve
                            ? CustomStyles.getDefaultThumbUpIcon(size: _iconSize)
                            : CustomStyles.getDefaultNotThumbUpIcon(size: _iconSize),
                        onPressed: _pushLike,
                      ),
                      Text(widget._comment.approvalCount.toString()),
                      IconButton(
                        icon: widget._comment.approvalStatus == ApprovalStatus.disapprove
                            ? CustomStyles.getDefaultThumbDownIcon(size: _iconSize)
                            : CustomStyles.getDefaultNotThumbDownIcon(size: _iconSize),
                        onPressed: _pushDislike,
                      ),
                      IconButton(
                        icon: CustomStyles.getDefaultReplyIcon(size: _iconSize),
                        onPressed: _pushReply,
                      )
                    ],
                  )
                ],
              )
              : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageList() => ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    itemCount: widget._comment.imageUrl.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          widget._comment.imageUrl[index],
          fit: BoxFit.fitWidth,
        ),
      ),
    ),
  );

  Padding _buildTitle() =>
      Padding(
        padding: const EdgeInsets.only(
          top: Constants.defaultCardPadding / 2,
          left: Constants.defaultCardPadding,
          right: Constants.defaultCardPadding,
          bottom: Constants.defaultCardPadding / 3,
        ),
        child: Text(
          widget._title,
          style: CustomStyles.postPageTitleStyle,
        ),
      );

  void _pushLike() {
    setState(() {
      switch (widget._comment.approvalStatus) {
        case ApprovalStatus.none:
          widget._comment.addApprovals();
          break;
        case ApprovalStatus.approve:
          widget._comment.subApprovals();
          break;
        case ApprovalStatus.disapprove:
          break;
      }
    });
  }

  void _pushDislike() {
    setState(() {
      switch (widget._comment.approvalStatus) {
        case ApprovalStatus.none:
          widget._comment.subApprovals();
          break;
        case ApprovalStatus.disapprove:
          widget._comment.addApprovals();
          break;
        case ApprovalStatus.approve:
          break;
      }
    });
  }

  void _pushReply() {}
}
