import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/widgets/comment_card.dart';
import 'package:comment_overflow/widgets/comment_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final Post _post;
  final List<Comment> _commentList;

  const PostPage(this._post, this._commentList, {Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var _sortPolicy = SortPolicy.earliest;
  var _stared = false;

  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  static const _iconSize = 20.0;
  static const _bottomIconSize = 30.0;

  String getPolicyName(SortPolicy policy) {
    switch (policy) {
      case SortPolicy.earliest:
        return "最早回复";
      case SortPolicy.latest:
        return "最近回复";
      case SortPolicy.hottest:
        return "最热回复";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("帖子 ${widget._post.postId.toString()}"),
        actions: <Widget>[
          IconButton(
            icon: CustomStyles.getDefaultDeleteIcon(size: _iconSize),
            tooltip: 'Delete this Post',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Post has been deleted.")));
            },
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: Constants.defaultCardPadding / 2,
              left: Constants.defaultCardPadding,
              right: Constants.defaultCardPadding,
              bottom: Constants.defaultCardPadding / 3,
            ),
            child: Text(
              widget._post.title,
              style: CustomStyles.postPageTitleStyle,
            ),
          ),
          CommentCard(widget._post.commentToDisplay),
          _gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<SortPolicy>(
                  padding: const EdgeInsets.all(7.0),
                  onSelected: (SortPolicy result) => {
                        setState(() {
                          _sortPolicy = result;
                        })
                      },
                  child: Row(
                    children: [
                      Text("${getPolicyName(_sortPolicy)}"),
                      CustomStyles.getDefaultArrowDownIcon(size: _iconSize),
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SortPolicy>>[
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
                      ]),
            ],
          ),
          _gap,
          Expanded(
            child: CommentCardList(widget._commentList),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            TextButton(
              onPressed: _pushReply,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomStyles.getDefaultReplyIcon(size: _bottomIconSize),
                  Text("回复", style: CustomStyles.postPageBottomStyle)
                ],
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget._post.commentToDisplay.approvalStatus ==
                            ApprovalStatus.approve
                        ? CustomStyles.getDefaultThumbUpIcon(
                            size: _bottomIconSize)
                        : CustomStyles.getDefaultNotThumbUpIcon(
                            size: _bottomIconSize),
                    Text(widget._post.commentToDisplay.approvalCount.toString(),
                        style: CustomStyles.postPageBottomStyle),
                  ],
                )),
            TextButton(
                onPressed: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget._post.commentToDisplay.approvalStatus ==
                            ApprovalStatus.disapprove
                        ? CustomStyles.getDefaultThumbDownIcon(
                            size: _bottomIconSize)
                        : CustomStyles.getDefaultNotThumbDownIcon(
                            size: _bottomIconSize),
                    Text("不赞同", style: CustomStyles.postPageBottomStyle),
                  ],
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    _stared = _stared ? false : true;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _stared
                        ? CustomStyles.getDefaultStaredIcon(
                            size: _bottomIconSize)
                        : CustomStyles.getDefaultNotStarIcon(
                            size: _bottomIconSize),
                    Text("Star", style: CustomStyles.postPageBottomStyle),
                  ],
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }

  void _pushReply() {
    showModalBottomSheet(
      isScrollControlled: true, // !important
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // !important
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
