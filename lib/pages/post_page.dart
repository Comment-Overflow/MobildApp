import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/comment_card_list.dart';
import 'package:comment_overflow/widgets/horizontal_image_scroller.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  List<AssetEntity> _assets = <AssetEntity>[];

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
              size: Constants.defaultFabIconSize, color: Colors.white)),
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
      builder: (BuildContext context) {
        return SingleChildScrollView(
            // !important
            child: _inputField);
      },
    );
  }

  Widget get _inputField => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 17.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CustomStyles.getDefaultCloseIcon(size: 16.0),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: QuoteCard(quotes[0]),
            ),
            HorizontalImageScroller(_assets),
            Row(
              children: [
                _textField,
                ElevatedButton(
                  child: Text("发送"),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      );

  Widget get _textField => Expanded(
        child: TextField(
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: "友善的回复",
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(6.0),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: CustomStyles.getDefaultImageIcon(size: 24.0),
                    onPressed: _selectAssets,
                  ),
                ],
              )),
          autofocus: true,
        ),
      );

  Future<void> _selectAssets() async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(context,
        maxAssets: Constants.maxImageNumber - _assets.length,
        selectedAssets: _assets);
    if (result != null) {
      setState(() {
        _assets = List<AssetEntity>.from(result);
      });
    }
  }
}
