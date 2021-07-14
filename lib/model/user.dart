import 'package:flutter/cupertino.dart';

class User {
  final String _userName;
  final ImageProvider _userAvatarImageProvider;
  final _brief;

  get userName => _userName;
  get userAvatarImageProvider => _userAvatarImageProvider;
  get brief => _brief;

  User(this._userName, this._userAvatarImageProvider, this._brief);

}