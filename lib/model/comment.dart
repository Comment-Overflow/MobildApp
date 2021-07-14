import 'package:zhihu_demo/model/user.dart';

class Comment {
  final User _user;
  final _content;
  final _quote;
  final _date;
  final _floor;
  int _approvalCount;

  get user => _user;
  get content => _content;
  get quote => _quote;
  get date => _date;
  get floor => _floor;

  int get approvalCount => _approvalCount;

  void addApprovals() => _approvalCount++;
  void subApprovals() => _approvalCount--;

  Comment(this._user, this._content, this._quote, this._date,
      this._floor, this._approvalCount);
}