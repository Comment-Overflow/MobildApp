import 'package:comment_overflow/model/user_info.dart';
import 'package:flutter/cupertino.dart';

class PrivateChatPageAccessDTO {
  final GlobalKey _key;
  final UserInfo _userInfo;

  GlobalKey get key => _key;

  UserInfo get userInfo => _userInfo;

  PrivateChatPageAccessDTO(this._key, this._userInfo);
}