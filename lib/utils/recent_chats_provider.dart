import 'dart:collection';

import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';

class RecentChatsProvider extends ChangeNotifier {

  int _totalUnreadCount = 0;
  Map<int, Chat> _chatMap = Map();
  List<Chat> _recentChats = [];

  int get totalUnreadCount => _totalUnreadCount;

  UnmodifiableListView<Chat> get recentChats =>
      UnmodifiableListView(_recentChats);

  // All operations are atomic.

  void add(Chat chat) {
    GlobalUtils.mutex.protect(() async {
      _chatMap.putIfAbsent(chat.chatter.userId, () => chat);
      _recentChats.add(chat);
      _totalUnreadCount += chat.unreadCount;
    });
    notifyListeners();
  }

  void removeAt(int index) {
    GlobalUtils.mutex.protect(() async {
      Chat chat = _recentChats[index];
      _chatMap.remove(chat.chatter.userId);
      _recentChats.removeAt(index);
      _totalUnreadCount -= chat.unreadCount;
    });
    notifyListeners();
  }

  void updateAll(List<Chat> chats, Map<int, Chat> chatMap) {
    GlobalUtils.mutex.protect(() async {
      _recentChats = chats;
      _chatMap = chatMap;
      _totalUnreadCount = 0;
      for (Chat chat in chats) {
        _totalUnreadCount += chat.unreadCount;
      }
    });
    notifyListeners();
  }

  void updateRead(UserInfo chatter) {
    GlobalUtils.mutex.protect(() async {
      Chat? chat = _chatMap[chatter.userId];
      if (chat != null) {
        _totalUnreadCount -= chat.unreadCount;
        chat.unreadCount = 0;
      }
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
        _totalUnreadCount -= chat.unreadCount;
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
        _totalUnreadCount = 1;
        Chat newChat = Chat(chatter, lastMessageContent, time, 1);
        _chatMap.putIfAbsent(chatter.userId, () => newChat);
        _recentChats.add(newChat);
      } else {
        _totalUnreadCount++;
        chat.lastMessageContent = lastMessageContent;
        chat.time = time;
        chat.unreadCount++;
      }
    });
    notifyListeners();
  }

  void removeAllChats() {
    GlobalUtils.mutex.protect(() async {
      _totalUnreadCount = 0;
      _chatMap.clear();
      _recentChats.clear();
    });
    notifyListeners();
  }

  void updateTotalUnreadCount(int totalUnreadCount) {
    GlobalUtils.mutex.protect(() async {
      _totalUnreadCount = totalUnreadCount;
    });
  }

  void _makeLatestMessage(int chatterId) {
    GlobalUtils.mutex.protect(() async {
      // TODO: _totalUnreadCount
      Chat? chat = _chatMap[chatterId];
      if (chat != null) {
        _recentChats.remove(chat);
        _recentChats.insert(0, chat);
      }
    });
  }
}
