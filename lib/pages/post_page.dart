import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/widgets/comment_card.dart';
import 'package:zhihu_demo/widgets/comment_card_list.dart';

class PostPage extends StatefulWidget {
  final Post _post;
  final List<Comment> _commentList;


  const PostPage(this._post, this._commentList, {Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var _sortPolicy = SortPolicy.earliest;

  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap:(){ Navigator.pop(context); },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("帖子 ${widget._post.postId.toString()}"),
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
            widget._post.title,
            style: CustomStyles.postTitleStyle,
          ),
          _gap,
          CommentCard(widget._post.commentToDisplay),
          _gap,
          PopupMenuButton<SortPolicy>(
            onSelected: (SortPolicy result) => {
              setState(() {_sortPolicy = result;})
            },
            child: Row(
              children: [
                Text("${_sortPolicy.toString()} |"),
                CustomStyles.getDefaultArrowDownIcon(),
              ],
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortPolicy>>[
              const PopupMenuItem(
                value: SortPolicy.earliest,
                child: Text("最早回复"),
              ),
              const PopupMenuItem(
                value: SortPolicy.latest,
                child: Text("最近回复"),
              ),
              const PopupMenuItem(
                value: SortPolicy.hottest,
                child: Text("最热回复"),
              ),
            ]
          ),
          _gap,
          CommentCardList(widget._commentList),
        ],
      ),
    );
  }
}