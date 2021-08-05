import 'package:comment_overflow/model/comment.dart';

class Post {
  final int _postId;
  final String _title;
  final int _commentCount;
  final int _approvalCount;
  // Depending on whether the comment is displayed as post or comment.
  final Comment _hostComment;
  bool isStarred;
  bool isFrozen;

  int get postId => _postId;
  String get title => _title;
  int get commentCount => _commentCount;
  int get approvalCount => _approvalCount;
  Comment get hostComment => _hostComment;

  Post(this._postId, this._title, this._commentCount, this._approvalCount,
      this._hostComment, this.isStarred, this.isFrozen);

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      json['id'] as int,
      json['title'] as String,
      json['commentCount'] as int,
      json['hostComment']['approvalCount'] as int,
      Comment.fromJson(json['hostComment']),
      json['isStarred'] as bool,
      json['isFrozen'] as bool);

  @override
  String toString() {
    return 'Post{_postId: $_postId, _title: $_title, _commentCount: $_commentCount, _approvalCount: $_approvalCount, _hostComment: $_hostComment, isStarred: $isStarred, isFrozen: $isFrozen}';
  }
}

class SearchedPost extends Post {
  final Comment _searchedComment;

  Comment get searchedComment => _searchedComment;

  SearchedPost.fromJson(dynamic json)
      : _searchedComment = Comment.fromJson(json['searchedComment']),
        super(
            json['id'] as int,
            json['title'] as String,
            json['commentCount'] as int,
            json['hostComment']['approvalCount'] as int,
            Comment.fromJson(json['hostComment']),
            json['isStarred'] as bool,
            json['isFrozen'] as bool);
}
