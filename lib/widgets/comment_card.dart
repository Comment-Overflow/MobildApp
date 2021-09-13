import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/storage_util.dart';
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
import 'package:skeletons/skeletons.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'adaptive_alert_dialog.dart';
import 'multiple_input_field.dart';

class CommentCard extends StatefulWidget {
  final Comment _comment;
  final int _postId;
  final String _title;
  final bool _highlight;
  final bool _isPostFrozen;
  final int _userId;
  final Function? _replyCallback;
  final Function? _jumpCallback;

  const CommentCard(this._comment, this._postId, this._userId,
      {Key? key,
      title = "",
      highlight = false,
      replyCallback,
      jumpCallback,
      isPostFrozen = false})
      : _title = title,
        _highlight = highlight,
        _replyCallback = replyCallback,
        _jumpCallback = jumpCallback,
        _isPostFrozen = isPostFrozen,
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
  late bool isDeleted;

  final List<AssetEntity> _assets = <AssetEntity>[];
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: Constants.defaultHighlightTime));
    _colorTween =
        ColorTween(begin: CustomColors.highlightGreen, end: Colors.white)
            .animate(
      CurvedAnimation(parent: _animationController, curve: Interval(0.5, 1.0)),
    );
    isDeleted = widget._comment.isDeleted;
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
                      widget._comment.user.userId,
                      Constants.defaultAvatarInCommentSize,
                      avatarUrl: widget._comment.user.avatarUrl,
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
              widget._comment.quote == null || isDeleted
                  ? SizedBox.shrink()
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _gap,
                        Expanded(
                            child: GestureDetector(
                                onTap: () => widget._jumpCallback!(
                                    widget._comment.quote!.floor),
                                child: QuoteCard(widget._comment.quote))),
                      ],
                    ),
              _gap,
              isDeleted
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(Constants.commentDeletedPrompt,
                            style: CustomStyles.commentDeletedStyle),
                      ))
                  : widget._comment.content.isNotEmpty
                      ? Text(
                          widget._comment.content,
                        )
                      : SizedBox.shrink(),
              _gap,
              ImageList(isDeleted ? [] : widget._comment.imageUrl),
              widget._comment.floor > 0 && !isDeleted
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
                        widget._isPostFrozen
                            ? Container()
                            : IconButton(
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
    );
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
        builder: (BuildContext replyContext) {
          return SafeArea(
            child: MultipleInputField(
              postId: widget._postId,
              context: replyContext,
              textController: _replyController,
              assets: _assets,
              quote: Quote.fromComment(widget._comment),
              finishCallback: widget._replyCallback == null
                  ? () {}
                  : widget._replyCallback!,
            ),
          );
        });
  }

  Future<void> _deleteComment() async {
    try {
      await PostService.deleteComment(widget._comment.id);
    } on DioError catch (e) {
      print(e.response!.data);
    }
  }

  Widget _buildDeleteButton() {
    okCallback() {
      _deleteComment();
      Navigator.pop(context);
      setState(() {
        isDeleted = true;
      });
      MessageBox.showToast(
          msg: "删除成功!", messageBoxType: MessageBoxType.Success);
    }

    cancelCallback() {
      Navigator.pop(context);
    }

    return (widget._userId == widget._comment.user.userId &&
                !widget._isPostFrozen) ||
            StorageUtil().loginInfo.userType == UserType.Admin
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

class SkeletonCommentCardList extends StatelessWidget {
  const SkeletonCommentCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(4, (index) => SkeletonCommentCard(index)),
    );
  }
}

class SkeletonCommentCard extends StatelessWidget {
  final int _index;

  const SkeletonCommentCard(this._index, {Key? key}) : super(key: key);

  static const _gap = const SizedBox(height: 15.0);
  static const _title = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 13.0,
  ));
  static final _block = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 100,
  ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child: SkeletonItem(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(_index == 0 ? [_title, _gap] : [SizedBox.shrink()]),
                    Row(children: [
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          height: Constants.defaultAvatarInCommentSize,
                          width: Constants.defaultAvatarInCommentSize,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 11,
                            width: 60,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ]),
                    _gap,
                    SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        spacing: 16,
                        padding: EdgeInsets.zero,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 11,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    _gap,
                    _block,
                  ]),
            )),
      ),
    );
  }
}
