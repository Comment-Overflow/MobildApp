import 'dart:collection';

import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:flutter/cupertino.dart';

class RecentChats extends ChangeNotifier {
  static final UserInfo _cyxInfo = UserInfo(1, "xx01cyx");

  final List<Chat> _recentChats = List<Chat>.filled(
    3,
    Chat(_cyxInfo, "Hi", DateTime.now(), 2),
    growable: true,
  );

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
