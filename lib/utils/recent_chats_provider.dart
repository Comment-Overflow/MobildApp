import 'dart:collection';
import 'dart:io';

import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:flutter/cupertino.dart';

class RecentChatsProvider extends ChangeNotifier {
  static final _chatterId = Platform.isIOS ? 1 : 2;
  static final UserInfo _cyxInfo = UserInfo(_chatterId, "xx01cyx");
  static final _mockChat = Chat(_cyxInfo, "", DateTime.now(), 0);

  // final Map<int, Chat> _chatMap = {_chatterId: _mockChat};
  // List<Chat> _recentChats = [_mockChat];
  final Map<int, Chat> _chatMap = Map();
  List<Chat> _recentChats = [];

  UnmodifiableListView<Chat> get recentChats =>
      UnmodifiableListView(_recentChats);


  void add(Chat chat) {
    _chatMap.putIfAbsent(chat.chatter.userId, () => chat);
    _recentChats.add(chat);
    notifyListeners();
  }

  void removeAt(int index) {
    Chat chat = _recentChats[index];
    _chatMap.remove(chat.chatter.userId);
    _recentChats.removeAt(index);
    notifyListeners();
  }

  void updateAll(List<Chat> chats) {
    _recentChats = chats;
  }

  void updateRead(UserInfo chatter) {
    print("enter update");
    Chat? chat = _chatMap[chatter.userId];
    if (chat != null) {
      print("updating");
      chat.unreadCount = 0;
    }
    notifyListeners();
  }

  void updateLastMessageRead(UserInfo chatter, String lastMessage, DateTime time) {
    Chat? chat = _chatMap[chatter.userId];
    if (chat == null) {
      print("SSS");
      Chat newChat = Chat(chatter, lastMessage, time, 0);
      _chatMap.putIfAbsent(chatter.userId, () => newChat);
      _recentChats.add(newChat);
    } else {
      print("AAA");
      chat.lastMessage = lastMessage;
      chat.time = time;
      chat.unreadCount = 0;
    }
    notifyListeners();
  }

  void updateUnread(UserInfo chatter, String lastMessage, DateTime time) {
    Chat? chat = _chatMap[chatter.userId];
    if (chat == null) {
      Chat newChat = Chat(chatter, lastMessage, time, 1);
      _chatMap.putIfAbsent(chatter.userId, () => newChat);
      _recentChats.add(newChat);
    } else {
      chat.lastMessage = lastMessage;
      chat.time = time;
      chat.unreadCount++;
    }
    notifyListeners();
  }

  void updateLastMessage(int chatterId, String lastMessage) {
    Chat? chat = _chatMap[chatterId];
    if (chat != null) chat.lastMessage = lastMessage;
    notifyListeners();
  }
}
