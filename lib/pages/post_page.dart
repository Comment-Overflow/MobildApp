import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/widgets/adaptive_alert_dialog.dart';
import 'package:comment_overflow/widgets/approval_button.dart';
import 'package:comment_overflow/widgets/comment_card_list.dart';
import 'package:comment_overflow/widgets/disapproval_button.dart';
import 'package:comment_overflow/widgets/multiple_input_field.dart';
import 'package:comment_overflow/widgets/star_button.dart';
import 'package:dio/dio.dart';
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
  final List<AssetEntity> _assets = <AssetEntity>[];
  final TextEditingController _replyController = TextEditingController();

  static const _iconSize = 20.0;
  static const _bottomIconSize = 24.0;

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
        elevation: Constants.defaultAppBarElevation,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("帖子 ${widget._post.postId.toString()}"),
        actions: <Widget>[
          FutureBuilder(future: _getUserId(), builder: _buildDeleteButton)
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _pushReply,
          child: CustomStyles.getDefaultReplyIcon(
              size: Constants.defaultFabIconSize, color: Colors.white)),
      body: CommentCardList(widget._post, this._sortPolicy),
      bottomNavigationBar: StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSetter) {
        int _usrId = widget._post.commentToDisplay.user.userId;
        return BottomAppBar(
          child: Row(
            children: [
              TextButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomStyles.getDefaultListIcon(size: _bottomIconSize),
                    Text("跳页"),
                  ],
                ),
                onPressed: () {},
              ),
              ApprovalButton(
                  comment: widget._post.commentToDisplay,
                  size: _bottomIconSize),
              DisapprovalButton(
                  comment: widget._post.commentToDisplay,
                  size: _bottomIconSize),
              StarButton(
                  initialStared: widget._post.isStarred,
                  postId: widget._post.postId,
                  userId: _usrId,
                  size: _bottomIconSize),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        );
      }),
    );
  }

  Widget _buildPageJumper(int currentPage, int totalPage) {
    return StatefulBuilder(
        builder: (BuildContext c, StateSetter s) {
          return Card(
            elevation: Constants.defaultCardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        TextButton(onPressed: () {}, child: Text("首页")),
                        Text("页面跳转"),
                        TextButton(onPressed: () {}, child: Text("末页"))
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                    Divider(),
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                    )
                  ],
                ),
              )
            ),
          );
        }
    );
  }

  Widget _buildDropDownMenu() {
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
            ]);
  }

  Future<int> _getUserId() async {
    return await GeneralUtils.getCurrentUserId();
  }

  Widget _buildDeleteButton(BuildContext context, AsyncSnapshot snapshot) {

    okCallback() {
      _deletePost();
      Navigator.pop(context);
      Navigator.pop(context);
      MessageBox.showToast(
          msg: "帖子已被删除，刷新以更新。",
          messageBoxType: MessageBoxType.Info);
    }

    cancelCallback() {
      Navigator.pop(context);
    }

    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
      case ConnectionState.active:
        return SizedBox.shrink();
      case ConnectionState.done:
        {
          int _userId = snapshot.data;
          return _userId == widget._post.commentToDisplay.user.userId
            ? IconButton(
              icon: CustomStyles.getDefaultDeleteIcon(size: _iconSize),
              tooltip: 'Delete this Post',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AdaptiveAlertDialog(
                        "删除帖子: ${widget._post.postId}",
                        "你确认要删除 \"${widget._post.title}\"吗",
                        "确定", "取消",
                        okCallback,
                        cancelCallback);
                  });
              })
            : SizedBox.shrink();
        }
    }
  }

  Future<void> _deletePost() async {
    try {
      await PostService.deletePost(widget._post.postId);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  void _pushReply() {
    showModalBottomSheet(
        isScrollControlled: true, // !important
        context: context,
        builder: (_) {
          return MultipleInputField(
            postId: widget._post.postId,
            context: context,
            textController: _replyController,
            assets: _assets,
            quote: null,
          );
        });
  }
}
