import 'package:zhihu_demo/model/user_info.dart';

class Message {

  final String _content;
  final DateTime _time;
  final UserInfo _sender;
  final UserInfo _receiver;
  final bool _hasRead;

  String get content => _content;
  DateTime get time => _time;
  UserInfo get sender => _sender;
  UserInfo get receiver => _receiver;
  bool get hasRead => _hasRead;

  Message(
      this._content, this._time, this._sender, this._receiver, this._hasRead);
}