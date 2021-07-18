import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        UserAvatarWithName(_post.commentToDisplay.user.userName, 20.0,
            textStyle: CustomStyles.postContentStyle, gap: 7.0),
        Text(
          _post.commentToDisplay.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final userAndContentColumnWithImage =
        _post.commentToDisplay.imageUrl.isNotEmpty
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
                          _post.commentToDisplay.imageUrl[0],
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
                    text:
                        ' ${_post.approvalCount} · ${_post.commentToDisplay.timeString}',
                  ),
                ],
                style: CustomStyles.postFooterStyle,
              ),
            )
          ]),
        ),
        onTap: () {
          Navigator.push(
              context,
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.postRoute,
                arguments: posts[0],
              )));
        },
      ),
    );
  }
}
