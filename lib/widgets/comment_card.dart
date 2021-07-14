import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/widgets/user_avatar_with_name.dart';

class CommentCard extends StatefulWidget {

  final Comment _comment;

  const CommentCard(this._comment, {Key? key}) : super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static const _gap = const SizedBox(height: 5.0);
  var liked = false;

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
                      image: widget._comment.user.userAvatarImageProvider,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget._comment.date,
                      style: CustomStyles.dateStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget._comment.floor,
                      style: CustomStyles.floorStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              _gap,
              //QuoteWidget(widget._comment.quote),
              _gap,
              RichText(
                text: widget._comment.content
              ),
              _gap,
              Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(liked ? Icons.favorite_border : Icons.favorite),
                      onPressed: _pushLike,
                      alignment: Alignment.centerRight,
                    )
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.comment_outlined),
                      onPressed: _pushComment,
                      alignment: Alignment.centerRight,
                    )
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
    if (liked) {
      liked = false;
      widget._comment.subApprovals();
    } else {
      liked = true;
      widget._comment.addApprovals();
    }
  }
  void _pushComment() {}
}