class Post {

  final String _title;
  final String _author;
  final String _content;
  final int _numOfApprovals;
  final int _numOfComments;
  final String _date;
  final String? _firstImageUrl;

  get title => _title;

  get author => _author;

  get content => _content;

  get numOfApprovals => _numOfApprovals;

  get numOfComments => _numOfComments;

  get date => _date;

  get firstImageUrl => _firstImageUrl;

  Post(this._title, this._author, this._content, this._numOfApprovals,
      this._numOfComments, this._date, this._firstImageUrl);
}