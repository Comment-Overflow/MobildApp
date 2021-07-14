import 'package:zhihu_demo/model/comment.dart';

class Post {
  final int _postId;
  final String _title;
  final int _commentCount;
  final int _approvalCount;
  // Depending on whether the comment is displayed as post or comment.
  final Comment _commentToDisplay;

  int get postId => _postId;
  String get title => _title;
  int get commentCount => _commentCount;
  int get approvalCount => _approvalCount;
  Comment get commentToDisplay => _commentToDisplay;

  Post(this._postId, this._title, this._commentCount, this._approvalCount,
      this._commentToDisplay);
}
