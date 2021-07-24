import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class MessageService {
  static Future<Response> sendTextMessage(
      String content, int receiverId) async {
    int senderId = await GeneralUtils.getCurrentUserId();
    return await HttpUtil().dio.post('/message/text', data: {
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }
}
