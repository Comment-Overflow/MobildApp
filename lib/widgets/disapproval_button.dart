import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisapprovalButton extends StatefulWidget {
  final Comment _comment;
  final bool _showText;
  final double _size;

  DisapprovalButton({required comment, showText = true, size = 30.0, Key? key})
      : _comment = comment,
        _showText = showText,
        _size = size,
        super(key: key);

  @override
  _DisapprovalButtonState createState() => _DisapprovalButtonState();
}

class _DisapprovalButtonState extends State<DisapprovalButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (_isLoading) return;
          switch (widget._comment.approvalStatus) {
            case ApprovalStatus.disapprove:
              setState(() {
                _isLoading = true;
              });
              NotificationService.deleteApproval(widget._comment.id,
                      widget._comment.user.userId, ApprovalStatus.disapprove)
                  .then((value) {
                setState(() {
                  widget._comment.addApprovals();
                  _isLoading = false;
                });
              }).onError((error, stackTrace) {
                MessageBox.showToast(
                    msg: "操作失败！", messageBoxType: MessageBoxType.Error);
                setState(() {
                  _isLoading = false;
                });
              });
              break;
            case ApprovalStatus.approve:
              break;
            case ApprovalStatus.none:
              setState(() {
                _isLoading = true;
              });
              NotificationService.postApproval(widget._comment.id,
                      widget._comment.user.userId, ApprovalStatus.disapprove)
                  .then((value) {
                setState(() {
                  widget._comment.subApprovals();
                  _isLoading = false;
                });
              }).onError((error, stackTrace) {
                MessageBox.showToast(
                    msg: "操作失败！", messageBoxType: MessageBoxType.Error);
                setState(() {
                  _isLoading = false;
                });
              });
              break;
          }
        },
        child: _isLoading
            ? CupertinoActivityIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget._comment.approvalStatus == ApprovalStatus.disapprove
                      ? CustomStyles.getDefaultThumbDownIcon(size: widget._size)
                      : CustomStyles.getDefaultNotThumbDownIcon(
                          size: widget._size),
                  widget._showText
                      ? Text("反对", style: CustomStyles.postPageBottomStyle)
                      : SizedBox.shrink(),
                ],
              ));
  }
}
