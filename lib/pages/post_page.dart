import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/widgets/comment_card_list.dart';

class PostPage extends StatelessWidget {
  final Post _post;
  final List<Comment> _commentList;

  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  const PostPage(this._post, this._commentList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap:(){ Navigator.pop(context); },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("帖子 ${_post.postId.toString()}"),
        actions: <Widget>[
          IconButton(
            icon: CustomStyles.getDefaultDeleteIcon(),
            tooltip: 'Delete this Post',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Post has been deleted."))
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            _post.title,
            style: CustomStyles.postTitleStyle,
          ),
          _gap,
          /// "Earliest Reply" list here
          _gap,
          CommentCardList(_commentList),
        ],
      ),
    );
  }
}