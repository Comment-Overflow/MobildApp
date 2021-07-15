import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserAvatar extends StatelessWidget {

  /// Diameter of the circular avatar.
  final double _imageSize;
  // TODO: Image represented as base64 or url?
  // Current using url.
  final ImageProvider<Object>? image;

  UserAvatar(
    this._imageSize, {
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// Whether use has set custom avatar. If not, fallback Icon is used.
    final bool isAvatarSet = this.image == null;

    return CircleAvatar(
      backgroundImage: this.image,
      backgroundColor: Colors.transparent,
      radius: this._imageSize / 2,
      child: isAvatarSet ? Icon(
        Icons.account_circle_rounded,
        size: _imageSize,) : null,
    );
  }
}