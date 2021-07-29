import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/widgets/approval_button.dart';
import 'package:comment_overflow/widgets/disapproval_button.dart';
import 'package:comment_overflow/widgets/image_list.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/user_avatar_with_name.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'adaptive_alert_dialog.dart';
import 'multiple_input_field.dart';

class CommentCard extends StatefulWidget {
  final Comment _comment;
  final int _postId;
  final String _title;
  final bool _highlight;
  final int _userId;

  const CommentCard(this._comment, this._postId, this._userId,
      {Key? key, title = "", highlight = false})
      : _title = title,
        _highlight = highlight,
        super(key: key);

  @override
  createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard>
    with SingleTickerProviderStateMixin {
  static const _gap = const SizedBox(height: 10.0);
  static const _iconSize = 17.0;

  late AnimationController _animationController;
  late Animation _colorTween;

  final List<AssetEntity> _assets = <AssetEntity>[];
  final TextEditingController _replyController = TextEditingController();

  // TODO: Change color transition.
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: Constants.defaultHighlightTime));
    _colorTween =
        ColorTween(begin: CustomColors.highlightBlue, end: Colors.white)
            .animate(
      CurvedAnimation(parent: _animationController, curve: Interval(0.5, 1.0)),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._highlight) {
      _highlightComment();
    }
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Card(
              color: widget._highlight ? _colorTween.value : Colors.white,
              elevation: Constants.defaultCardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Constants.defaultCardPadding,
                      right: Constants.defaultCardPadding,
                      top: Constants.defaultCardPadding,
                      bottom: widget._comment.floor == 0
                          ? Constants.defaultCardPadding
                          : Constants.defaultCardPadding / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...(widget._comment.floor == 0 && widget._title.isNotEmpty
                          ? [_buildTitle(), _gap]
                          : [SizedBox.shrink()]),
                      Row(
                        children: [
                          Expanded(
                            child: UserAvatarWithName(
                              widget._comment.user.userName,
                              Constants.defaultAvatarInCommentSize,
                              image: widget._comment.user.avatarUrl == null
                                  ? null
                                  : NetworkImage(
                                      widget._comment.user.avatarUrl!),
                            ),
                          ),
                          Text(
                            widget._comment.timeString,
                            style: CustomStyles.dateStyle,
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget._comment.floor > 0
                                ? widget._comment.floorString + '楼'
                                : "",
                            style: CustomStyles.floorStyle,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      _gap,
                      widget._comment.quote == null
                          ? SizedBox.shrink()
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                _gap,
                                Expanded(
                                    child: QuoteCard(widget._comment.quote)),
                              ],
                            ),
                      _gap,
                      Text(
                        widget._comment.content,
                      ),
                      _gap,
                      ImageList(widget._comment.imageUrl),
                      widget._comment.floor > 0
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ApprovalButton.horizontal(
                                  comment: widget._comment,
                                  size: _iconSize,
                                ),
                                DisapprovalButton(
                                  comment: widget._comment,
                                  size: _iconSize,
                                  showText: false,
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  icon: CustomStyles.getDefaultReplyIcon(
                                      size: _iconSize),
                                  onPressed: _pushReply,
                                ),
                                _buildDeleteButton(),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ));
  }

  Future _highlightComment() async {
    await _animationController.forward();
  }

  Padding _buildTitle() => Padding(
        padding: const EdgeInsets.only(
          top: Constants.defaultCardPadding / 2,
          bottom: Constants.defaultCardPadding / 3,
        ),
        child: Text(
          widget._title,
          style: CustomStyles.postPageTitleStyle,
        ),
      );

  void _pushReply() {
    showModalBottomSheet(
        isScrollControlled: true, // !important
        context: context,
        builder: (_) {
          return MultipleInputField(
            postId: widget._postId,
            context: context,
            textController: _replyController,
            assets: _assets,
            quote: Quote.fromComment(widget._comment),
          );
        });
  }

  Future<void> _deleteComment() async {
    try {
      await PostService.deleteComment(widget._comment.id);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Widget _buildDeleteButton() {
    okCallback() {
      _deleteComment();
      Navigator.pop(context);
      MessageBox.showToast(
          msg: "回复已被删除，刷新以更新。", messageBoxType: MessageBoxType.Success);
    }

    cancelCallback() {
      Navigator.pop(context);
    }

    return widget._userId == widget._comment.user.userId
        ? IconButton(
            splashColor: Colors.transparent,
            icon: CustomStyles.getDefaultDeleteIcon(size: _iconSize),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AdaptiveAlertDialog(
                        "删除回复",
                        "你确认要删除第${widget._comment.floor}楼的回复吗",
                        "确定",
                        "取消",
                        okCallback,
                        cancelCallback);
                  });
            },
          )
        : SizedBox.shrink();
  }
}
