import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';

class Message {
  final String? _uuid;
  final MessageType _type;
  DateTime? time;
  final UserInfo _sender;
  final UserInfo _receiver;
  final dynamic _content;
  bool isSending = true;

  String? get uuid => _uuid;

  MessageType get type => _type;

  UserInfo get sender => _sender;

  UserInfo get receiver => _receiver;

  dynamic get content => _content;

  Message(this._type, this._sender, this._receiver, this._content, {uuid, time})
      : _uuid = uuid,
        time = time;
}
