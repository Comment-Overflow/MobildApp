import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/service/admin_service.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/storage_util.dart';
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
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostPage extends StatefulWidget {
  final Post _post;
  final int _pageIndex;

  const PostPage(this._post, {Key? key, pageIndex: 0})
      : _pageIndex = pageIndex,
        super(key: key);

  @override
  _PostPageState createState() => _PostPageState(_pageIndex);
}

class _PostPageState extends State<PostPage> {
  final List<AssetEntity> _assets = <AssetEntity>[];
  final TextEditingController _replyController = TextEditingController();

  static const _iconSize = 20.0;
  static const _bottomIconSize = 24.0;

  int _pageIndex;
  int _currentPageNum;

  _PostPageState(this._pageIndex)
      : _currentPageNum = _pageIndex ~/ Constants.defaultPageSize;

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
        title: Text(
            "帖子 ${widget._post.postId.toString() + (widget._post.isFrozen ? " (已锁定)" : "")}"),
        actions: <Widget>[
          FutureBuilder(future: _getUserId(), builder: _buildDeleteButton),
          _buildFreezeButton()
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: widget._post.isFrozen ? null : _pushReply,
          backgroundColor: widget._post.isFrozen ? Colors.grey : null,
          child: CustomStyles.getDefaultReplyIcon(
              size: Constants.defaultFabIconSize, color: Colors.white)),
      body: FutureBuilder(
        future: _getUserId(),
        builder: _buildCommentCardList,
      ),
      bottomNavigationBar: StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSetter) {
        int _usrId = widget._post.hostComment.user.userId;
        return BottomAppBar(
          child: Row(
            children: [
              TextButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomStyles.getDefaultListIcon(size: _bottomIconSize),
                    Text("跳页", style: CustomStyles.postPageBottomStyle),
                  ],
                ),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) => _buildPageJumper());
                },
              ),
              ApprovalButton(
                  comment: widget._post.hostComment, size: _bottomIconSize),
              DisapprovalButton(
                  comment: widget._post.hostComment, size: _bottomIconSize),
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

  Widget _buildFreezeButton() {
    bool isFreezeLoading = false;

    Future<void> _freezePost(StateSetter setter) async {
      setter(() {
        isFreezeLoading = true;
      });
      try {
        await AdminService.freezePost(widget._post.postId);
        setState(() {
          widget._post.isFrozen = true;
          isFreezeLoading = false;
        });
      } on DioError catch (e) {
        MessageBox.showToast(
            msg: e.message, messageBoxType: MessageBoxType.Error);
        setter(() {
          isFreezeLoading = false;
        });
      }
    }

    Future<void> _releasePost(StateSetter setter) async {
      setter(() {
        isFreezeLoading = true;
      });
      try {
        await AdminService.releasePost(widget._post.postId);
        setState(() {
          widget._post.isFrozen = false;
          isFreezeLoading = false;
        });
      } on DioError catch (e) {
        MessageBox.showToast(
            msg: e.message, messageBoxType: MessageBoxType.Error);
        setter(() {
          isFreezeLoading = false;
        });
      }
    }

    return StorageUtil().loginInfo.userType == UserType.Admin
        ? StatefulBuilder(builder: (bc, s) {
            if (isFreezeLoading) return CupertinoActivityIndicator();

            freezeCallback() {
              _freezePost(s);
              Navigator.pop(context);
            }

            releaseCallback() {
              _releasePost(s);
              Navigator.pop(context);
            }

            cancelCallback() {
              Navigator.pop(context);
            }

            if (widget._post.isFrozen) {
              return IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AdaptiveAlertDialog(
                              "解锁帖子",
                              "你确认要解除帖子 ${widget._post.title} 的锁定吗",
                              "确定",
                              "取消",
                              releaseCallback,
                              cancelCallback);
                        });
                  },
                  icon: CustomStyles.getReleaseIcon(size: _iconSize));
            } else {
              return IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AdaptiveAlertDialog(
                              "锁定帖子",
                              "你确认要锁定帖子 ${widget._post.title} 吗",
                              "确定",
                              "取消",
                              freezeCallback,
                              cancelCallback);
                        });
                  },
                  icon: CustomStyles.getFreezeIcon(size: _iconSize));
            }
          })
        : Container();
  }

  Widget _buildPageJumper() {
    return Consumer<MaxPageCounter>(
      builder: (context1, counter, child) =>
          StatefulBuilder(builder: (BuildContext c, StateSetter s) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 8.0),
          child: Card(
              elevation: Constants.defaultCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context1);
                                setState(() {
                                  _pageIndex = 0;
                                });
                              },
                              child: Text("首页",
                                  style: CustomStyles.jumpPageStyle)),
                          Text("页面跳转", style: CustomStyles.jumpPageStyle),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context1);
                                setState(() {
                                  _pageIndex =
                                      counter.value * Constants.defaultPageSize;
                                });
                              },
                              child:
                                  Text("末页", style: CustomStyles.jumpPageStyle))
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      Divider(),
                      SizedBox(
                        height: counter.value > 9 ? 200 : null,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing:
                                        Constants.defaultNinePatternSpacing,
                                    crossAxisSpacing:
                                        Constants.defaultNinePatternSpacing,
                                    childAspectRatio: 1.0),
                            shrinkWrap: true,
                            itemCount: counter.value + 1,
                            itemBuilder: (context2, index) {
                              return index == _currentPageNum
                                  ? Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            shape: MaterialStateProperty.all(
                                                CircleBorder())),
                                        child: Text((index + 1).toString(),
                                            style:
                                                CustomStyles.currentPageStyle),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        Navigator.pop(context1);
                                        setState(() {
                                          _pageIndex =
                                              index * Constants.defaultPageSize;
                                        });
                                      },
                                      child: Text((index + 1).toString(),
                                          style: CustomStyles.otherPageStyle));
                            }),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }),
    );
  }

  Future<int> _getUserId() async {
    return await GeneralUtils.getCurrentUserId();
  }

  Widget _buildDeleteButton(BuildContext context, AsyncSnapshot snapshot) {
    okCallback() {
      _deletePost();
      Navigator.pop(context);
      Navigator.pop(context);
      MessageBox.showToast(msg: "帖子已被删除!", messageBoxType: MessageBoxType.Info);
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
          return _userId == widget._post.hostComment.user.userId ||
                  StorageUtil().loginInfo.userType == UserType.Admin
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
                              "确定",
                              "取消",
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
      print(e.response!.data);
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
            finishCallback: _pushReplyCallback,
          );
        });
  }

  Widget _buildCommentCardList(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
      case ConnectionState.active:
        return SizedBox.shrink();
      case ConnectionState.done:
        {
          int _userId = snapshot.data;
          return CommentCardList(widget._post, _userId, _pushReplyCallback,
              _setMaxPageCallback, _pushReplyCallback, (pageNum) {
            _currentPageNum = pageNum;
          }, pageIndex: _pageIndex);
        }
    }
  }

  _pushReplyCallback(pageIndex) => setState(() {
        _pageIndex = pageIndex;
        _assets.clear();
      });

  _setMaxPageCallback(int maxPage) {
    context.read<MaxPageCounter>().setValue(maxPage);
  }
}

class MaxPageCounter with ChangeNotifier {
  int value = 0;

  void setValue(int newValue) {
    if (value != newValue) {
      value = newValue;
      notifyListeners();
    }
  }
}
