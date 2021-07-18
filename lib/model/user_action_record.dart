import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/model/user_info.dart';

class ApprovalRecord {
  UserInfo _userInfo;
  DateTime _time;
  Quote _approvedComment;

  UserInfo get userInfo => _userInfo;
  DateTime get time => _time;
  Quote get approvedComment => _approvedComment;

  ApprovalRecord(this._userInfo, this._time, this._approvedComment);
}

class ReplyRecord {
  UserInfo _userInfo;
  DateTime _time;
  String _content;
  Quote _repliedQuote;

  UserInfo get userInfo => _userInfo;
  DateTime get time => _time;
  String get content => _content;
  Quote get repliedQuote => _repliedQuote;

  ReplyRecord(this._userInfo, this._time, this._content, this._repliedQuote);
}

class FollowRecord {
  UserInfo _userInfo;
  DateTime _time;
  FollowStatus _followStatus;

  UserInfo get userInfo => _userInfo;
  FollowRecord(this._userInfo, this._time, this._followStatus);
  DateTime get time => _time;

  FollowStatus get followStatus => _followStatus;
}

class StarRecord {
  UserInfo _userInfo;
  DateTime _time;
  Quote _starredPost;

  UserInfo get userInfo => _userInfo;
  StarRecord(this._userInfo, this._time, this._starredPost);
  DateTime get time => _time;

  Quote get starredPost => _starredPost;
}
