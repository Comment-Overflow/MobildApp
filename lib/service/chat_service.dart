import 'dart:io';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class ChatService {
  static Future<Response> sendImage(int receiverId, File imageFile) async {
    FormData formData = FormData.fromMap({
      'receiverId': receiverId,
      'imageFile': MultipartFile.fromFileSync(imageFile.path)
    });
    return HttpUtil().dio.post('/chat/image', data: formData);
  }

  static Future<Response> getChatHistory(int chatterId, int pageNumber) async {
    int currentUserId = await GeneralUtils.getCurrentUserId();
    return HttpUtil().dio.get('/chat-history', queryParameters: {
      'userId': currentUserId,
      'chatterId': chatterId,
      'pageNum': pageNumber,
      'pageSize': Constants.HTTPChatHistoryPage,
    });
  }

  static Future<Response> getRecentChats() async {
    int currentUserId = await GeneralUtils.getCurrentUserId();
    return HttpUtil().dio.get('/recent-chats', queryParameters: {
      'userId': currentUserId,
    });
  }
}
