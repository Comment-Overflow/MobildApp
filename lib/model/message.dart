import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';

class Message {
  final MessageType _type;
  final DateTime _time;
  final UserInfo _sender;
  final UserInfo _receiver;
  final bool _hasRead;
  final String _content;

  MessageType get type => _type;

  DateTime get time => _time;

  UserInfo get sender => _sender;

  UserInfo get receiver => _receiver;

  bool get hasRead => _hasRead;

  String get content => _content;

  Message(this._type, this._time, this._sender, this._receiver, this._hasRead,
      this._content);
}
