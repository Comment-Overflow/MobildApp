
class MyComment {

  final String _postTitle;
  final String _content;
  final String _imageUrl;
  
  String get postTitle => _postTitle;
  
  String get content => _content;
  
  String get imageUrl => _imageUrl;
  
  MyComment(this._postTitle, this._content, this._imageUrl);
}