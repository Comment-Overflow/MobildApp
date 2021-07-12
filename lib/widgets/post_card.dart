import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/post.dart';

class PostCard extends StatelessWidget {

  final Post _post;
  static const _gap = const SizedBox(height: 5.0);

  const PostCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post.title,
                  style: CustomStyles.postTitleStyle,
                ),
                _gap,
                Text(
                  _post.author,
                ),
                _gap,
                Text(
                  _post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                _gap,
                Text(
                  '${_post.numOfApprovals}赞同 · '
                      '${_post.numOfComments}评论 · '
                      '${_post.date}',
                  style: CustomStyles.postFooterStyle,
                ),
              ]
          ),
        ),
        onTap: () => {},
      ),
    );
  }
}