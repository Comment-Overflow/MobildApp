import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/model/request_dto/new_comment_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'horizontal_image_scroller.dart';

class MultipleInputField extends StatelessWidget {
  final BuildContext _context;

  /// Holds text in TextField.
  final TextEditingController _controller;

  /// Holds selected images.
  final List<AssetEntity> _assets;

  /// Quote of this reply. (if any)
  final Quote? _quote;

  final int _postId;

  bool _isLoading = false;

  /// The function to call after sending reply.
  final Function _finishCallback;
  /*
    Usage:
    add [onTap] property for reply button
  ================================================
    void _pushReply() {
    showModalBottomSheet(
      isScrollControlled: true, // !important
      context: context,
      builder: (_) {
        return MultipleInputField(
            context: context,
            textController: _replyController,
            assets: _assets,
            quote: _quote,
        );
      }
    );
  }
  ================================================
  */

  MultipleInputField(
      {required BuildContext context,
      required TextEditingController textController,
      required List<AssetEntity> assets,
      required int postId,
      required Function finishCallback,
      Quote? quote,
      Key? key})
      : _context = context,
        _controller = textController,
        _assets = assets,
        _quote = quote,
        _postId = postId,
        _finishCallback = finishCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 25,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CustomStyles.getDefaultCloseIcon(size: 20.0),
                  )
                ],
              ),
            ),
            _quote == null
                ? SizedBox.shrink()
                : Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: QuoteCard(_quote),
                      ))
                    ],
                  ),
            HorizontalImageScroller(_assets),
            Row(
              children: [
                _buildTextField(),
                Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: StatefulBuilder(builder: (c, s) {
                      Future<void> _postComment() async {
                        if (_controller.text.isEmpty) {
                          MessageBox.showToast(
                              msg: "回复文字不能为空",
                              messageBoxType: MessageBoxType.Error);
                          return;
                        }
                        final dto = NewCommentDTO(
                            postId: _postId,
                            quoteId: _quote == null ? 0 : _quote!.commentId,
                            content: _controller.text,
                            assets: _assets);
                        try {
                          s(() {
                            _isLoading = true;
                          });
                          final response = await PostService.postComment(dto);
                          MessageBox.showToast(
                              msg: "回复成功",
                              messageBoxType: MessageBoxType.Success);
                          s(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                          _finishCallback(response.data);
                          _controller.clear();
                          _assets.clear();
                        } on DioError catch (e) {
                          if (e.response != null &&
                              e.response!.statusCode == 401) {
                            MessageBox.showToast(
                                msg: "发送回复失败: 您已被禁言",
                                messageBoxType: MessageBoxType.Error);
                            s(() {
                              _isLoading = false;
                            });
                            Navigator.pop(context);
                            return;
                          }
                          MessageBox.showToast(
                              msg: "发送回复失败: ${e.response!.data}",
                              messageBoxType: MessageBoxType.Error);
                          s(() {
                            _isLoading = false;
                          });
                        }
                      }

                      return _isLoading
                          ? ElevatedButton(
                              onPressed: null,
                              child: CupertinoActivityIndicator())
                          : ElevatedButton(
                              child: Text("发送"),
                              onPressed: _postComment,
                            );
                    }))
              ],
            ),
          ]),
    ));
  }

  Widget _buildTextField() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "友善的回复向世界问好",
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
    ));
  }

  Future<void> _selectAssets() async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(_context,
        maxAssets: Constants.maxImageNumber, selectedAssets: _assets);
    if (result != null) {
      _assets.clear();
      _assets.addAll(List<AssetEntity>.from(result));
    }
  }
}
