import 'package:comment_overflow/model/request_dto/new_post_dto.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class PostService {
  static Future<Response> postPost(NewPostDTO newPost) async {
    return await HttpUtil()
        .dio
        .post('/post', data: await newPost.formData());
  }
  static Future<Response> getPost(int postId) async {
    return await HttpUtil()
        .dio
        .get('/post', queryParameters: {'postId': postId});
  }
}