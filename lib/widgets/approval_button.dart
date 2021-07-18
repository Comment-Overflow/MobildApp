import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovalButton extends StatefulWidget {
  final Comment _comment;
  final int _userId;

  ApprovalButton({
    required comment,
    required userId,
    Key? key
  }) : _comment = comment,
        _userId = userId,
        super(key: key);

  @override
  _ApprovalButtonState createState() => _ApprovalButtonState();
}

class _ApprovalButtonState extends State<ApprovalButton> {
  static const _bottomIconSize = 30.0;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget._comment.approvalStatus == ApprovalStatus.approve
              ? CustomStyles.getDefaultThumbUpIcon(size: _bottomIconSize)
              : CustomStyles.getDefaultNotThumbUpIcon(size: _bottomIconSize),
            Text(widget._comment.approvalCount.toString(),
                style: CustomStyles.postPageBottomStyle),
          ],
        ));
  }
}