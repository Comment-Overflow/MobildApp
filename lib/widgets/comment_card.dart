import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/widgets/reference_card.dart';
import 'package:zhihu_demo/widgets/user_avatar_with_name.dart';

class CommentCard extends StatefulWidget {
  final Comment _comment;

  const CommentCard(this._comment, {Key? key}) : super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static const _gap = const SizedBox(height: 5.0);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: UserAvatarWithName(
                      widget._comment.user.userName,
                      Constants.defaultAvatarInCommentSize,
                      image: NetworkImage(widget._comment.user.avatarUrl),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget._comment.timeString,
                      style: CustomStyles.dateStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget._comment.floorString + '楼',
                      style: CustomStyles.floorStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              widget._comment.quote == null
                  ? SizedBox.shrink()
                  : Row(
                      children: [
                        _gap,
                        QuoteCard(widget._comment.quote),
                      ],
                    ),
              _gap,
              RichText(
                text: TextSpan(
                  text: widget._comment.content,
                  style: CustomStyles.commentContentStyle,
                ),
              ),
              _gap,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: CustomStyles.getDefaultDeleteIcon(),
                    onPressed: () => {},
                  ),
                  IconButton(
                    icon: widget._comment.approvalStatus == ApprovalStatus.approve
                        ? CustomStyles.getDefaultThumbUpIcon()
                        : CustomStyles.getDefaultNotThumbUpIcon(),
                    onPressed: _pushLike,
                  ),
                  Text(widget._comment.approvalCount.toString()),
                  IconButton(
                    icon: widget._comment.approvalStatus == ApprovalStatus.disapprove
                        ? CustomStyles.getDefaultThumbDownIcon()
                        : CustomStyles.getDefaultNotThumbDownIcon(),
                    onPressed: _pushDislike,
                  ),
                  IconButton(
                    icon: CustomStyles.getDefaultReplyIcon(),
                    onPressed: _pushReply,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pushLike() {
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
  }

  void _pushDislike() {
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
  }

  void _pushReply() {}
}
