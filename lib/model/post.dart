class Post {

  final _title;
  final _author;
  final _content;
  final _numOfApprovals;
  final _numOfComments;
  final _date;

  get title => _title;

  get author => _author;

  get content => _content;

  get numOfApprovals => _numOfApprovals;

  get numOfComments => _numOfComments;

  get date => _date;

  Post(this._title, this._author, this._content, this._numOfApprovals,
      this._numOfComments, this._date);
}