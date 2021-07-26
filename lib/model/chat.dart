import 'package:comment_overflow/model/user_info.dart';

class Chat {
  final UserInfo _chatter;
  String lastMessageContent;
  DateTime time;
  int unreadCount;

  UserInfo get chatter => _chatter;

  Chat(this._chatter, this.lastMessageContent, this.time, this.unreadCount);

  factory Chat.fromJson(dynamic json) {
    return Chat(
        UserInfo.fromJson(json['minimalChatterInfo']),
        json['lastMessageContent'] as String,
        DateTime.parse(json['time'] as String),
        json['unreadCount'] as int);
  }
}
