import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/my_comment.dart';

class MyCommentCard extends StatelessWidget {

  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);
  final MyComment _myComment;

  const MyCommentCard(this._myComment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentContentColumn = Column(
        children: [
          Text(
            _myComment.content,
            style: CustomStyles.myCommentContentStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          _gap,
          Text(
            _myComment.postTitle,
            style: CustomStyles.myCommentPostTitleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ]
    );

    /// If the post contains an images, display the first on the left, taking up
    /// 3/4 of the entire width.
    final contentColumnWithImage = _myComment.imageUrl.isNotEmpty
        ? IntrinsicHeight(
        child: Row(children: [
          Expanded(
            flex: 14,
            child: commentContentColumn,
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
                    _myComment.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
        ]))
        : commentContentColumn;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                contentColumnWithImage,
                _gap,
              ]
          ),
        ),
        onTap: () => {},
      ),
    );
  }
}
