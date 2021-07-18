import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisapprovalButton extends StatefulWidget {
  final Comment _comment;
  final int _userId;
  final bool _showText;
  final double _size;

  DisapprovalButton({
    required comment,
    required userId,
    showText = true,
    size = 30.0,
    Key? key
  }) : _comment = comment,
        _userId = userId,
        _showText = showText,
        _size = size,
        super(key: key);

  @override
  _DisapprovalButtonState createState() => _DisapprovalButtonState();
}

class _DisapprovalButtonState extends State<DisapprovalButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          switch (widget._comment.approvalStatus) {
            case ApprovalStatus.disapprove:
              setState(() {widget._comment.addApprovals();});
              break;
            case ApprovalStatus.approve: break;
            case ApprovalStatus.none:
              setState(() {widget._comment.subApprovals();});
              break;
          }
          /// Send request here
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget._comment.approvalStatus == ApprovalStatus.disapprove
              ? CustomStyles.getDefaultThumbDownIcon(size: widget._size)
              : CustomStyles.getDefaultNotThumbDownIcon(size: widget._size),
            widget._showText
              ? Text("不赞同", style: CustomStyles.postPageBottomStyle)
              : SizedBox.shrink(),
          ],
        ));
  }
}

