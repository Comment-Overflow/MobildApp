import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  final bool _initialStared;
  final int _postId;
  final int _userId;
  final double _size;
  StarButton(
      {required initialStared,
      required postId,
      required userId,
      size: 30.0,
      Key? key})
      : _initialStared = initialStared,
        _postId = postId,
        _userId = userId,
        _size = size,
        super(key: key);

  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  late bool _stared = widget._initialStared;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          if (_stared) {
            NotificationService.deleteStar(widget._userId, widget._postId).then((value) {
              setState(() {
                _stared = false;
                _isLoading = false;
              });
            }).onError((error, stackTrace) {
              MessageBox.showToast(
                  msg: "操作失败！", messageBoxType: MessageBoxType.Error);
              setState(() {
                _isLoading = false;
              });
            });
          } else {
            NotificationService.postStar(widget._userId, widget._postId).then((value) {
              setState(() {
                _stared = true;
                _isLoading = false;
              });
            }).onError((error, stackTrace) {
              MessageBox.showToast(
                  msg: "操作失败！", messageBoxType: MessageBoxType.Error);
              setState(() {
                _isLoading = false;
              });
            });
          }
        },
        child: _isLoading
            ? CupertinoActivityIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _stared
                      ? CustomStyles.getDefaultStaredIcon(size: widget._size)
                      : CustomStyles.getDefaultNotStarIcon(size: widget._size),
                  Text("收藏", style: CustomStyles.postPageBottomStyle),
                ],
              ));
  }
}
