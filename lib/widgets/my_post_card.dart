import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyPostCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final Post _post;

  const MyPostCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postContentColumn = Column(children: [
      Text(
        _post.hostComment.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      )
    ]);

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final contentColumnWithImage = _post.hostComment.imageUrl.isNotEmpty
        ? IntrinsicHeight(
            child: Row(children: [
            Expanded(
              flex: 14,
              child: postContentColumn,
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
                      _post.hostComment.imageUrl[0],
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
          ]))
        : postContentColumn;

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
            Text(
              _post.title,
              style: CustomStyles.postTitleStyle,
            ),
            _gap,
            contentColumnWithImage,
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
                    text:
                        ' ${_post.approvalCount} · ${_post.hostComment.timeString}',
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
