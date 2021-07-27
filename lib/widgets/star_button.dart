import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/service/notification_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (_stared) {
            NotificationService.deleteStar(widget._userId, widget._postId);
          } else {
            NotificationService.postStar(widget._userId, widget._postId);
          }
          setState(() {
            _stared = !_stared;
          });
        },
        child: Column(
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
