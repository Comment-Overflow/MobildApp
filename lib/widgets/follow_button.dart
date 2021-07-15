import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/adaptive_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final String userName;
  final FollowStatus _followStatus;

  FollowButton(this.userName, this._followStatus, {Key? key}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState(this._followStatus);
}

class _FollowButtonState extends State<FollowButton> {
  FollowStatus followStatus;

  _FollowButtonState(FollowStatus followStatus) : followStatus = followStatus;

  @override
  Widget build(BuildContext context) {
    final Row notFollowedByMeText = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultPlusIcon(),
        Text("关注", style: TextStyle(color: Colors.blue)),
      ],
    );

    final Row followedByMeText = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultTickIcon(),
        Text(" 已关注", style: TextStyle(color: Colors.white)),
      ],
    );

    final Row bidirectionalFollowText = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultBidirectionalFollowIcon(),
        Text(" 相互关注", style: TextStyle(color: Colors.white)),
      ],
    );

    final ButtonStyle addFollowButtonStyle = ButtonStyle(
      foregroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
      backgroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).buttonColor),
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
      foregroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).disabledColor),
      backgroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).disabledColor),
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
        followStatus = FollowStatus.none;
      });
      Navigator.of(context).pop();
    }

    cancelCallback() {
      Navigator.of(context).pop();
    }

    return Container(
      alignment: Alignment.center,
      child: TextButton(
        child: followStatus == FollowStatus.followedByMe
            ? followedByMeText
            : (followStatus == FollowStatus.both
                ? bidirectionalFollowText
                : notFollowedByMeText),
        onPressed: () {
          if (followStatus == FollowStatus.followedByMe ||
              followStatus == FollowStatus.both) {
            showDialog(
                context: context,
                builder: (context) {
                  return AdaptiveAlertDialog(
                      "取消关注",
                      "你将不再关注@" + widget.userName,
                      "确定",
                      "取消",
                      okCallback,
                      cancelCallback);
                });
          } else {
            setState(() {
              followStatus = FollowStatus.followedByMe;
            });
          }
        },
        style: followStatus == FollowStatus.followedByMe ||
                followStatus == FollowStatus.both
            ? hasFollowedButtonStyle
            : addFollowButtonStyle,
      ),
    );
  }
}
