import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';

class Message {
  final MessageType _type;
  DateTime? time;
  final UserInfo _sender;
  final UserInfo _receiver;
  final dynamic _content;
  MessageStatus status;

  MessageType get type => _type;

  UserInfo get sender => _sender;

  UserInfo get receiver => _receiver;

  dynamic get content => _content;

  Message(this._type, this._sender, this._receiver, this._content,
      {uuid, time, status = MessageStatus.Sending})
      : time = time,
        status = status;

  factory Message.fromJson(dynamic json) {
    MessageType messageType = ((json['type'] as String) == 'TEXT')
        ? MessageType.Text
        : MessageType.Image;
    return Message(
        messageType,
        UserInfo.fromJson(json['minimalSenderInfo']),
        UserInfo.fromJson(json['minimalReceiverInfo']),
        json['content'] as String,
        time: DateTime.parse(json['time'] as String),
        status: MessageStatus.Normal);
  }

  /// Get the message content to display in chat card.
  String getLastMessageContent() {
    return type == MessageType.Text ? content : Constants.imageLastMessage;
  }
}
