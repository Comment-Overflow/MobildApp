import 'package:comment_overflow/model/user_info.dart';
import 'package:flutter/cupertino.dart';

enum NotificationType { approvePost, approveComment, collect, attention, reply }

class NotificationMessage {
  final UserInfo _userInfo;
  //userAvatar
  final double _imageSize;
  final ImageProvider<Object>? _image;
  final TextStyle? _textStyle;
  final double _gap;

  final String? _title;
  final String? _comment;
  final NotificationType _type;

  get userInfo => _userInfo;

  get imageSize => _imageSize;

  get image => _image;

  get textStyle => _textStyle;

  get gap => _gap;

  get title => _title;

  get comment => _comment;

  get type => _type;

  NotificationMessage(this._userInfo, this._imageSize, this._gap, this._type,
      {ImageProvider<Object>? image,
      TextStyle? textStyle,
      String? title,
      String? comment})
      : _image = image,
        _textStyle = textStyle,
        _title = title,
        _comment = comment;
}
