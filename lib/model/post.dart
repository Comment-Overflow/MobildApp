import 'package:comment_overflow/model/comment.dart';

class Post {
  final int _postId;
  final String _title;
  final int _commentCount;
  final int _approvalCount;
  // Depending on whether the comment is displayed as post or comment.
  final Comment _commentToDisplay;
  final bool _isStarred;

  int get postId => _postId;
  String get title => _title;
  int get commentCount => _commentCount;
  int get approvalCount => _approvalCount;
  Comment get commentToDisplay => _commentToDisplay;
  bool get isStarred => _isStarred;

  Post(this._postId, this._title, this._commentCount, this._approvalCount,
      this._commentToDisplay, this._isStarred);

  factory Post.fromJson(dynamic json) => Post(
    json['id'] as int,
    json['title'] as String,
    json['commentCount'] as int,
    json['hostComment']['approvalCount'] as int,
    Comment.fromJson(json['hostComment']),
    json['isStarred'] as bool
  );
}
