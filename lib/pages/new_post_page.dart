import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
    );
  }

  buildAppBar() => AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomStyles.getDefaultBackIcon(context,
              size: Constants.searchBarHeight * 0.8),
          Text("发布帖子"),
        ]),
        automaticallyImplyLeading: false,
      );
}
