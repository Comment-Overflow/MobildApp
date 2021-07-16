import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/widgets/comment_card_list.dart';
import 'package:comment_overflow/widgets/multiple_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostPage extends StatefulWidget {
  final Post _post;

  const PostPage(this._post, {Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var _sortPolicy = SortPolicy.earliest;
  var _stared = false;
  final List<AssetEntity> _assets = <AssetEntity>[];
  final TextEditingController _replyController = TextEditingController();

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
      floatingActionButton: FloatingActionButton(
        onPressed: _pushReply,
        child: CustomStyles.getDefaultReplyIcon(
            size: _bottomIconSize, color: Colors.white
        )
      ),
      body: CommentCardList(posts[0]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            buildDropDownMenu(),
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

  Widget buildDropDownMenu() {
    return PopupMenuButton<SortPolicy>(
        padding: const EdgeInsets.all(7.0),
        onSelected: (SortPolicy result) => {
              setState(() {
                _sortPolicy = result;
              })
            },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomStyles.getDefaultListIcon(size: _bottomIconSize),
            Text(
              "${getPolicyName(_sortPolicy)}",
              style: CustomStyles.postPageBottomStyle,
            ),
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
            ]);
  }

  void _pushReply() {
    showModalBottomSheet(
      isScrollControlled: true, // !important
      context: context,
      builder: (_) {
        return MultipleInputField(
          context: context,
          textController: _replyController,
          assets: _assets,
          quote: quotes[0],
        );
      }
    );
  }
}

