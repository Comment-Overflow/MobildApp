import 'package:zhihu_demo/model/user.dart';

class Comment {
  final User _user;
  final _content;
  final _quote;
  final _date;
  final _floor;
  num _numOfApprovals;

  get user => _user;
  get content => _content;
  get quote => _quote;
  get date => _date;
  get floor => _floor;

  num get numOfApprovals => _numOfApprovals;

  void addApprovals() => _numOfApprovals++;

  Comment(this._user, this._content, this._quote, this._date,
      this._floor, this._numOfApprovals);
}