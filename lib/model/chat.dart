import 'package:zhihu_demo/model/user_info.dart';

class Chat {

  final UserInfo _chatter;
  final String _lastMessage;
  final DateTime _time;
  final int _unreadCount;

  DateTime get time => _time;
  String get lastMessage => _lastMessage;
  UserInfo get chatter => _chatter;
  int get unreadCount => _unreadCount;

  Chat(this._chatter, this._lastMessage, this._time, this._unreadCount);

}