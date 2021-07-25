import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/request_dto/chat_history_dto.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class MessageService {
  static Future<Response> getChatHistory(int chatterId, int pageNumber) async {
    int currentUserId = await GeneralUtils.getCurrentUserId();
    return HttpUtil().dio.get('/chat-history', queryParameters: {
      'userId': currentUserId,
      'chatterId': chatterId,
      'pageNum': pageNumber,
      'pageSize': Constants.defaultHTTPChatHistoryPageSize,
    });
  }
}
