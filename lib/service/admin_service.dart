import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class AdminService {
  static Future<Response> silenceUser(int silenceUserId) async {
    return await HttpUtil().dio.put('/silence/' + silenceUserId.toString());
  }

  static Future<Response> freeUser(int freeUserId) async {
    return await HttpUtil().dio.put('/freedom/' + freeUserId.toString());
  }

  static Future<Response> freezePost(int freezePostId) async {
    return await HttpUtil().dio.put('/freeze/' + freezePostId.toString());
  }

  static Future<Response> releasePost(int releasePostId) async {
    return await HttpUtil().dio.put('/release/' + releasePostId.toString());
  }
}
