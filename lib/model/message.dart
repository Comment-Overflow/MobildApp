import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';

class Message {
  final MessageType _type;
  final DateTime _time;
  final UserInfo _sender;
  final UserInfo _receiver;
  final bool _hasSent;
  final dynamic _content;

  MessageType get type => _type;

  DateTime get time => _time;

  UserInfo get sender => _sender;

  UserInfo get receiver => _receiver;

  bool get hasSent => _hasSent;

  dynamic get content => _content;

  Message(this._type, this._time, this._sender, this._receiver, this._hasSent,
      this._content);
}
