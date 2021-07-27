import 'dart:io';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/socket_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatService {

  static Future initChat() async {
    // TODO: Toast on error.
    int totalUnreadCount = (await ChatService.getTotalUnreadCount()).data as int;
    BuildContext context = GlobalUtils.navKey!.currentContext!;
    context.read<RecentChatsProvider>().updateTotalUnreadCount(totalUnreadCount);
    await SocketClient().init();
  }

  static Future disposeChat() async {
    await SocketClient().deleteReadChats();
    SocketClient().dispose();
    BuildContext context = GlobalUtils.navKey!.currentContext!;
    context.read<RecentChatsProvider>().removeAllChats();
  }

  static Future<Response> sendText(int receiverId, String content) async {
    FormData formData = FormData.fromMap({
      'receiverId': receiverId,
      'content': content,
    });
    return HttpUtil().dio.post('/chat/text', data: formData);
  }

  static Future<Response> sendImage(int receiverId, File imageFile) async {
    FormData formData = FormData.fromMap({
      'receiverId': receiverId,
      'imageFile': MultipartFile.fromFileSync(imageFile.path)
    });
    return HttpUtil().dio.post('/chat/image', data: formData);
  }

  static Future<Response> getChatHistory(int chatterId, int pageNumber) async {
    return HttpUtil().dio.get('/chat-history', queryParameters: {
      'chatterId': chatterId,
      'pageNum': pageNumber,
      'pageSize': Constants.HTTPChatHistoryPage,
    });
  }

  static Future deleteChat(int chatterId) async {
    return SocketClient().deleteChat(chatterId);
  }

  static Future<Response> getRecentChats() async {
    return HttpUtil().dio.get('/recent-chats');
  }

  static Future<Response> getTotalUnreadCount() async {
    return HttpUtil().dio.get('/unread-chats');
  }
}
