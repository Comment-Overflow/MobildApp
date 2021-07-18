import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  final bool _initialStared;
  final int _postId;
  final int _userId;
  StarButton({
    required initialStared,
    required postId,
    required userId,
    Key? key
  }) : _initialStared = initialStared,
        _postId = postId,
        _userId = userId,
        super(key: key);
  
  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  late bool _stared = widget._initialStared;
  static const _bottomIconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          setState(() {
            _stared = !_stared;
            /// Send request here
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stared
                ? CustomStyles.getDefaultStaredIcon(size: _bottomIconSize)
                : CustomStyles.getDefaultNotStarIcon(size: _bottomIconSize),
            Text("Star", style: CustomStyles.postPageBottomStyle),
          ],
        ));
  }
}