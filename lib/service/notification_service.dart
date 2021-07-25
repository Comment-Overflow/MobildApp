import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class NotificationService {
  static Future<Response> getNotification(page, pageSize, String url) async {
    return await HttpUtil().dio.get(url, queryParameters: {
      'page': page, 'pageSize': pageSize
    });
  }
}