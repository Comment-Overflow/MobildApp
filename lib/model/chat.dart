import 'package:comment_overflow/model/user_info.dart';

class Chat {

  final UserInfo _chatter;
  String lastMessage;
  DateTime time;
  int unreadCount;

  UserInfo get chatter => _chatter;

  Chat(this._chatter, this.lastMessage, this.time, this.unreadCount);

}