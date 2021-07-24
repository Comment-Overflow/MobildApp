import 'dart:collection';

import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:flutter/cupertino.dart';

class RecentChats extends ChangeNotifier {
  static final UserInfo _cyxInfo = UserInfo(
      1, "xx01cyx", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");

  final List<Chat> _recentChats = List<Chat>.filled(
    3,
    Chat(_cyxInfo, "Hi", DateTime.now(), 2),
    growable: true,
  )
    ..addAll(List<Chat>.filled(
      3,
      Chat(_cyxInfo, "Very long long long long long long long long message",
          DateTime(2021, 7, 18, 21, 3), 0),
      growable: true,
    ))
    ..addAll(List<Chat>.filled(
      3,
      Chat(_cyxInfo, "很长很长很长很长很长很长很长很长很长很长很长很长很长的中文消息", DateTime(2020), 3),
      growable: true,
    ));

  UnmodifiableListView<Chat> get recentChats =>
      UnmodifiableListView(_recentChats);

  void add(Chat chat) {
    _recentChats.add(chat);
    notifyListeners();
  }

  void removeAt(int index) {
    _recentChats.removeAt(index);
    notifyListeners();
  }
}
