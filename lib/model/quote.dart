import 'package:comment_overflow/model/comment.dart';

class Quote {
  // Title can be user name, or post title.
  final int _commentId;
  final String _title;
  final String _content;
  final int _floor;

  int get commentId => _commentId;
  String get title => _title;
  String get content => _content;
  int get floor => _floor;

  Quote(this._commentId, this._title, this._content, this._floor);

  factory Quote.fromJson(dynamic json) => Quote(
      json['commentId'] as int,
      json['title'] as String,
      json['content'] as String,
      json['floor'] as int
  );

  Quote.fromComment(Comment comment)
    : this._commentId = comment.id,
      this._title = comment.user.userName,
      this._content = comment.content,
      this._floor = comment.floor;

}
