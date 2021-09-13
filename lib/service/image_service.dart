import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class ImageService {
  static Future<Response> getImageBytes(String imageUrl) async {
    return await HttpUtil()
        .dio
        .get(imageUrl, options: Options(responseType: ResponseType.bytes));
  }
}
