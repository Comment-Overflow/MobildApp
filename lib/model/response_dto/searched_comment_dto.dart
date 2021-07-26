import 'package:comment_overflow/model/comment.dart';

class SearchedCommentDTO {
  final int _postId;
  final String _title;
  final Comment _comment;

  int get postId => _postId;
  String get title => _title;
  Comment get comment => _comment;

  SearchedCommentDTO.fromJson(Map<String, dynamic> json)
      : _postId = json['postId'],
        _title = json['title'],
        _comment = Comment.fromJson(json['comment']);
}
