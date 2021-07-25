import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class SearchService {
  static final Dio _dio = HttpUtil().dio;

  static Future<Response> searchComment(
      String searchKey, int pageNum, int pageSize,
      {PostTag? postTag}) async {
    return await _dio.get("/comments", queryParameters: {
      'postTag': postTag,
      'searchKey': searchKey,
      'pageNum': pageNum,
      'pageSize': pageSize,
    });
  }
}
