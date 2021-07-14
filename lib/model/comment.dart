import 'package:intl/intl.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/quote.dart';
import 'package:zhihu_demo/model/user_info.dart';

class Comment {
  final UserInfo user;
  final String _content;
  final DateTime _time;
  final Quote _quote;
  final int _floor;
  int _approvalCount;
  final ApprovalStatus _approvalStatus;
  List<String> _imageUrl;

  String get content => _content;
  DateTime get time => _time;
  String get timeString => DateFormat("yyyy-MM-dd").format(_time);
  Quote get quote => _quote;
  int get floor => _floor;
  String get floorString => _floor.toString();
  int get approvalCount => _approvalCount;
  ApprovalStatus get approvalStatus => _approvalStatus;
  List<String> get imageUrl => _imageUrl;

  Comment(this.user, this._content, this._time, this._quote, this._floor,
      this._approvalCount, this._approvalStatus, this._imageUrl);

  void addApprovals() => ++_approvalCount;
  void subApprovals() => --_approvalCount;
}
