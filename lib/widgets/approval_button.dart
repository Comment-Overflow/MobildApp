import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovalButton extends StatefulWidget {
  final Comment _comment;
  final int _userId;
  final bool _showCount;
  final double _size;

  ApprovalButton({
    required comment,
    required userId,
    showCount = true,
    size = 30.0,
    Key? key
  }) : _comment = comment,
        _userId = userId,
        _showCount = showCount,
        _size = size,
        super(key: key);

  ApprovalButton.horizontal({
    required comment,
    required userId,
    showCount = false,
    size = 30.0,
    Key? key
  }) : _comment = comment,
        _userId = userId,
        _showCount = showCount,
        _size = size,
        super(key: key);

  @override
  _ApprovalButtonState createState() => _ApprovalButtonState();
}

class _ApprovalButtonState extends State<ApprovalButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          switch (widget._comment.approvalStatus) {
            case ApprovalStatus.disapprove: break;
            case ApprovalStatus.approve:
              setState(() {widget._comment.subApprovals();});
              break;
            case ApprovalStatus.none:
              setState(() {widget._comment.addApprovals();});
              break;
          }
          /// Send request here
        },
        child: widget._showCount? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget._comment.approvalStatus == ApprovalStatus.approve
              ? CustomStyles.getDefaultThumbUpIcon(size: widget._size)
              : CustomStyles.getDefaultNotThumbUpIcon(size: widget._size),
            Text(
              widget._comment.approvalCount.toString(),
              style: CustomStyles.postPageBottomStyle)
          ],
        ) : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget._comment.approvalStatus == ApprovalStatus.approve
                ? CustomStyles.getDefaultThumbUpIcon(size: widget._size)
                : CustomStyles.getDefaultNotThumbUpIcon(size: widget._size),
            Text(
                widget._comment.approvalCount.toString(),
                style: CustomStyles.postPageBottomStyle)
          ],
        )
    );
  }
}