import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class NotificationService {
  static Future<Response> getNotification(page, pageSize, String url) async {
    return await HttpUtil()
        .dio
        .get(url, queryParameters: {'page': page, 'pageSize': pageSize});
  }

  static Future<Response> postStar(int toUserId, int postId) async {
    return await HttpUtil()
        .dio
        .post('/records/stars', data: {'toUserId': toUserId, 'postId': postId});
  }

  static Future<Response> postApproval(
      int commentId, int toUserId, ApprovalStatus status) async {
    return await HttpUtil().dio.post('/records/approvals', data: {
      'commentId': commentId,
      'toUserId': toUserId,
      'status': statusString[status]
    });
  }

  static Future<Response> deleteStar(int toUserId, int postId) async {
    return await HttpUtil().dio.delete('/records/stars',
        data: {'toUserId': toUserId, 'postId': postId});
  }

  static Future<Response> deleteApproval(
      int commentId, int toUserId, ApprovalStatus status) async {
    return await HttpUtil().dio.delete('/records/approvals', data: {
      'commentId': commentId,
      'toUserId': toUserId,
      'status': statusString[status]
    });
  }
}
