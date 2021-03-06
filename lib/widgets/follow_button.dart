import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/widgets/adaptive_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final int _userId;
  final String userName;
  final FollowStatus _followStatus;

  FollowButton(this._userId, this.userName, this._followStatus, {Key? key})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState(this._followStatus);
}

class _FollowButtonState extends State<FollowButton> {
  FollowStatus _followStatus;
  bool _isOtherFollowing;
  bool _isLoading = false;

  _FollowButtonState(FollowStatus followStatus)
      : _followStatus = followStatus,
        _isOtherFollowing = followStatus == FollowStatus.followingCurrentUser ||
            followStatus == FollowStatus.both;

  @override
  Widget build(BuildContext context) {
    okCallback() {
      setState(() {
        _isLoading = true;
      });
      NotificationService.deleteFollow(widget._userId).then((value) {
        setState(() {
          _isLoading = false;
          _followStatus = FollowStatus.none;
        });
        Navigator.of(context).pop();
      });
    }

    cancelCallback() {
      Navigator.of(context).pop();
    }

    return SizedBox(
      height: Constants.defaultTextButtonHeight,
      child: TextButton(
        child: _isLoading
            ? _buildLoadingFollowText()
            : _followStatus == FollowStatus.followedByCurrentUser
                ? _buildFollowedByMeText()
                : (_followStatus == FollowStatus.both
                    ? _buildBidirectionalFollowText()
                    : _buildNotFollowedByMeText()),
        onPressed: () {
          if (_isLoading) return;
          if (_followStatus == FollowStatus.followedByCurrentUser ||
              _followStatus == FollowStatus.both) {
            showDialog(
                context: context,
                builder: (context) {
                  return AdaptiveAlertDialog(
                      "????????????",
                      "??????????????????@" + widget.userName,
                      "??????",
                      "??????",
                      okCallback,
                      cancelCallback);
                });
          } else {
            setState(() {
              _isLoading = true;
            });
            NotificationService.postFollow(widget._userId).then((value) {
              setState(() {
                _isLoading = false;
                _followStatus = _isOtherFollowing
                    ? FollowStatus.both
                    : FollowStatus.followedByCurrentUser;
              });
            });
          }
        },
        style: _followStatus == FollowStatus.followedByCurrentUser ||
                _followStatus == FollowStatus.both
            ? _buildHasFollowedButtonStyle()
            : _buildAddFollowButtonStyle(),
      ),
    );
  }

  Widget _buildNotFollowedByMeText() {
    Color accentColor = Theme.of(context).accentColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultPlusIcon(color: accentColor),
        Text("??????",
            style: TextStyle(
                fontSize: Constants.defaultButtonTextSize, color: accentColor)),
      ],
    );
  }

  Widget _buildFollowedByMeText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultTickIcon(),
        Text(" ?????????",
            style: TextStyle(
                fontSize: Constants.defaultButtonTextSize,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildBidirectionalFollowText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomStyles.getDefaultBidirectionalFollowIcon(),
        Text(" ????????????",
            style: TextStyle(
                fontSize: Constants.defaultButtonTextSize,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildLoadingFollowText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[CupertinoActivityIndicator()],
    );
  }

  ButtonStyle _buildAddFollowButtonStyle() {
    return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: Constants.defaultTextButtonPadding)),
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
  }

  ButtonStyle _buildHasFollowedButtonStyle() {
    return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: Constants.defaultTextButtonPadding)),
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed))
            return Theme.of(context).buttonColor;
          return Theme.of(context).primaryColor;
        },
      ),
    );
  }
}
