import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/widgets.dart';

class UserAvatarWithName extends StatelessWidget {
  final UserAvatar _userAvatar;
  final String _userName;

  /// Font size of user name
  final TextStyle? textStyle;

  /// Gap between avatar and user name.
  final double gap;

  UserAvatarWithName(
    this._userName,
    imageSize, {
    Key? key,
    image,
    this.textStyle,
    this.gap = 10.0,
  })  : _userAvatar = UserAvatar(imageSize, image: image),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userAvatar,
        SizedBox(width: this.gap),
        Expanded(
            child: Text(
          _userName,
          style: this.textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }
}
