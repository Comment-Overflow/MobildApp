import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/widgets/user_avatar.dart';

class UserAvatarWithName extends StatelessWidget {

  final UserAvatar _userAvatar;
  final String _userName;
  /// Font size of user name
  final double fontSize;
  /// Gap between avatar and user name.
  final double gap;

  UserAvatarWithName(
    this._userName,
    imageSize, {
      Key? key,
      image,
      this.fontSize = 16.0,
      this.gap = 10.0,
    }
  ) : _userAvatar =
    UserAvatar(imageSize, image: image),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userAvatar,
        SizedBox(width: this.gap),
        Text(
          _userName,
          style: TextStyle(fontSize: fontSize),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
