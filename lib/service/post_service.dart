import 'package:comment_overflow/model/request_dto/comments_query_dto.dart';
import 'package:comment_overflow/model/request_dto/new_comment_dto.dart';
import 'package:comment_overflow/model/request_dto/new_post_dto.dart';
import 'package:comment_overflow/model/request_dto/post_query_dto.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class PostService {
  static Future<Response> postPost(NewPostDTO newPost) async {
    return await HttpUtil().dio.post('/post', data: await newPost.formData());
  }

  static Future<Response> getPost(int postId) async {
    return await HttpUtil()
        .dio
        .get('/post', queryParameters: {'postId': postId});
  }

  static Future<Response> getPostComments(CommentQueryDTO query) async {
    return await HttpUtil().dio.get('/posts', queryParameters: query.getData());
  }

  static Future<Response> getPosts(PostQueryDTO query) async {
    return await HttpUtil().dio.get('/posts', queryParameters: query.getData());
  }

  static Future<Response> postComment(NewCommentDTO newComment) async {
    return await HttpUtil()
        .dio
        .post('/comment', data: await newComment.formData());
  }

  static Future<Response> deletePost(int postId) async {
    return await HttpUtil()
        .dio
        .delete('/post', queryParameters: {'postId': postId});
  }

  static Future<Response> deleteComment(int commentId) async {
    return await HttpUtil()
        .dio
        .delete('/comment', queryParameters: {'commentId': commentId});
  }
}
