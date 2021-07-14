import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/widgets/adaptive_alert_dialog.dart';

class FollowButton extends StatefulWidget {

  final String username;
  final bool _isFollowing;

  FollowButton(this._isFollowing, this.username, {Key? key}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState(this._isFollowing);

}

class _FollowButtonState extends State<FollowButton> {

  bool _isFollowing;

  _FollowButtonState(bool isFollowing) : _isFollowing = isFollowing;
  
  @override
  Widget build(BuildContext context) {

    final Text followText = Text(
        "Follow",
        style: TextStyle(color: Colors.blue)
    );

    final Text followingText = Text(
      "Following",
      style: TextStyle(color: Colors.white)
    );

    final ButtonStyle addFollowButtonStyle = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).accentColor
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).buttonColor
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed))
            return Theme.of(context).buttonColor;
          return Theme.of(context).primaryColor;
        },
      ),
    );

    final ButtonStyle hasFollowedButtonStyle = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
          Colors.grey.withOpacity(0.5)
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
          Colors.grey.withOpacity(0.5)
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed))
            return Theme.of(context).buttonColor;
          return Theme.of(context).primaryColor;
        },
      ),
    );

    okCallback() {
      setState(() {
        _isFollowing = !_isFollowing;
      });
      Navigator.of(context).pop();
    }

    cancelCallback() {
      Navigator.of(context).pop();
    }

    return Container(
      alignment: Alignment.center,
      child: TextButton(
        child: _isFollowing ? followingText : followText,
        onPressed: () {

          if (_isFollowing) {
            showDialog(context: context, builder: (context) {
              return AdaptiveAlertDialog(
                  "取消关注",
                  "你将不再关注@" + widget.username,
                  "确定",
                  "取消",
                  okCallback,
                  cancelCallback);
            });
            // showOkCancelAlertDialog(
            //   context: context,
            //   title:  "Sure to unfollow?",
            //   okLabel: "Yes",
            //   cancelLabel: "Cancel",
            // );
          } else {
            setState(() {
              _isFollowing = !_isFollowing;
            });
          }
        },
        style: _isFollowing ? hasFollowedButtonStyle : addFollowButtonStyle,
      ),
    );
  }
}

