import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/model/post.dart';

class PostPage extends StatelessWidget {
  final Post _post;

  const PostPage(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap:(){ Navigator.pop(context); },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("帖子 ${_post.postId.toString()}"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}