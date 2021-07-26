import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';

class RecentChatsProvider extends ChangeNotifier {
  static final _chatterId = Platform.isIOS ? 1 : 2;
  static final UserInfo _cyxInfo = UserInfo(_chatterId, "xx01cyx");
  static final _mockChat = Chat(_cyxInfo, "", DateTime.now(), 0);

  // final Map<int, Chat> _chatMap = {_chatterId: _mockChat};
  // List<Chat> _recentChats = [_mockChat];
  Map<int, Chat> _chatMap = Map();
  List<Chat> _recentChats = [];

  UnmodifiableListView<Chat> get recentChats =>
      UnmodifiableListView(_recentChats);

  // All operations are atomic.

  void add(Chat chat) {
    GlobalUtils.mutex.protect(() async {
      _chatMap.putIfAbsent(chat.chatter.userId, () => chat);
      _recentChats.add(chat);
    });
    notifyListeners();
  }

  void removeAt(int index) {
    GlobalUtils.mutex.protect(() async {
      Chat chat = _recentChats[index];
      _chatMap.remove(chat.chatter.userId);
      _recentChats.removeAt(index);
    });
    notifyListeners();
  }

  void updateAll(List<Chat> chats, Map<int, Chat> chatMap) {
    GlobalUtils.mutex.protect(() async {
      _recentChats = chats;
      _chatMap = chatMap;
    });
    notifyListeners();
  }

  void updateRead(UserInfo chatter) {
    GlobalUtils.mutex.protect(() async {
      Chat? chat = _chatMap[chatter.userId];
      if (chat != null)
        chat.unreadCount = 0;
    });
    notifyListeners();
  }

  void updateLastMessageRead(
      UserInfo chatter, String lastMessageContent, DateTime time) {
    GlobalUtils.mutex.protect(() async {
      Chat? chat = _chatMap[chatter.userId];
      if (chat == null) {
        Chat newChat = Chat(chatter, lastMessageContent, time, 0);
        _chatMap.putIfAbsent(chatter.userId, () => newChat);
        _recentChats.add(newChat);
      } else {
        chat.lastMessageContent = lastMessageContent;
        chat.time = time;
        chat.unreadCount = 0;
      }
    });
    notifyListeners();
  }

  void updateLastMessageUnread(UserInfo chatter, String lastMessageContent, DateTime time) {
    GlobalUtils.mutex.protect(() async {
      Chat? chat = _chatMap[chatter.userId];
      if (chat == null) {
        Chat newChat = Chat(chatter, lastMessageContent, time, 1);
        _chatMap.putIfAbsent(chatter.userId, () => newChat);
        _recentChats.add(newChat);
      } else {
        chat.lastMessageContent = lastMessageContent;
        chat.time = time;
        chat.unreadCount++;
      }
    });
    notifyListeners();
  }

  void _makeLatestMessage(int chatterId) {
    GlobalUtils.mutex.protect(() async {
      Chat? chat = _chatMap[chatterId];
      if (chat != null) {
        _recentChats.remove(chat);
        _recentChats.insert(0, chat);
      }
    });
  }
}
