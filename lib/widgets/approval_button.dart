import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovalButton extends StatefulWidget {
  final Comment _comment;
  final bool _showCount;
  final double _size;

  ApprovalButton({required comment, showCount = true, size = 30.0, Key? key})
      : _comment = comment,
        _showCount = showCount,
        _size = size,
        super(key: key);

  ApprovalButton.horizontal(
      {required comment, showCount = false, size = 30.0, Key? key})
      : _comment = comment,
        _showCount = showCount,
        _size = size,
        super(key: key);

  @override
  _ApprovalButtonState createState() => _ApprovalButtonState();
}

class _ApprovalButtonState extends State<ApprovalButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (_isLoading) return;
          switch (widget._comment.approvalStatus) {
            case ApprovalStatus.disapprove:
              break;
            case ApprovalStatus.approve:
              setState(() {
                _isLoading = true;
              });
              NotificationService.deleteApproval(widget._comment.id,
                      widget._comment.user.userId, ApprovalStatus.approve)
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
            case ApprovalStatus.none:
              setState(() {
                _isLoading = true;
              });
              NotificationService.postApproval(widget._comment.id,
                      widget._comment.user.userId, ApprovalStatus.approve)
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
          }

          /// Send request here
        },
        child: _isLoading
            ? CupertinoActivityIndicator()
            : widget._showCount
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget._comment.approvalStatus == ApprovalStatus.approve
                          ? CustomStyles.getDefaultThumbUpIcon(
                              size: widget._size)
                          : CustomStyles.getDefaultNotThumbUpIcon(
                              size: widget._size),
                      Text(widget._comment.approvalCount.toString(),
                          style: CustomStyles.postPageBottomStyle)
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget._comment.approvalStatus == ApprovalStatus.approve
                          ? CustomStyles.getDefaultThumbUpIcon(
                              size: widget._size)
                          : CustomStyles.getDefaultNotThumbUpIcon(
                              size: widget._size),
                      Text(widget._comment.approvalCount.toString(),
                          style: CustomStyles.postPageBottomStyle)
                    ],
                  ));
  }
}
