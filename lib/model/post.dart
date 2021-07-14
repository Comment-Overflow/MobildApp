class Post {

  final String _title;
  final String _author;
  final String _content;
  final int _approvalCount;
  final int _commentCount;
  final String _date;
  final String? _firstImageUrl;

  get title => _title;

  get author => _author;

  get content => _content;

  get approvalCount => _approvalCount;

  get commentCount => _commentCount;

  get date => _date;

  get firstImageUrl => _firstImageUrl;

  Post(this._title, this._author, this._content, this._approvalCount,
      this._commentCount, this._date, this._firstImageUrl);
}