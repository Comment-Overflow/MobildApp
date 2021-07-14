import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/widgets/user_avatar_with_name.dart';

class PostCard extends StatelessWidget {

  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final Post _post;

  const PostCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userAndContentColumn = Column(
      children: [
        UserAvatarWithName(_post.author + _post.author, 24.0,
            textStyle: CustomStyles.postContentStyle, gap: 7.0),
        _gap,
        Text(
          _post.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final userAndContentColumnWithImage = _post.firstImageUrl != null
        ? IntrinsicHeight(
            child: Row(children: [
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
                    child: Image.network(
                      _post.firstImageUrl,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
          ]))
        : userAndContentColumn;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _post.title,
              style: CustomStyles.postTitleStyle,
            ),
            _gap,
            userAndContentColumnWithImage,
            _gap,
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: CustomStyles.getDefaultReplyIcon(),
                  ),
                  TextSpan(
                    text: ' ${_post.commentCount} · ',
                  ),
                  WidgetSpan(
                    child: CustomStyles.getDefaultThumbUpIcon(),
                  ),
                  TextSpan(
                    text: ' ${_post.approvalCount} · ${_post.date}',
                  ),
                ],
                style: CustomStyles.postFooterStyle,
              ),
            )
          ]),
        ),
        onTap: () => {},
      ),
    );
  }
}
