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

  factory ApprovalRecord.fromJson(dynamic json) {
    int timeStamp = json['timestamp'] as int;
    return ApprovalRecord(
        UserInfo(
            json['fromUserUserId'] as int, json['fromUserUserName'] as String,
            avatarUrl: json['fromUserAvatarUrl'] as String),
        DateTime.fromMillisecondsSinceEpoch(timeStamp),
        Quote(json['commentId'] as int,
            json['commentPostTitle'] as String,
            json['commentContent'] as String,
            json['commentFloor'] as int));
  }
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

  factory ReplyRecord.fromJson(dynamic json) {
    int timestamp = json['timestamp'] as int;
    return ReplyRecord(
        UserInfo(
            json['fromUserUserId'] as int, json['fromUserUserName'] as String, avatarUrl: json['fromUserAvatarUrl'] as String),
        DateTime.fromMillisecondsSinceEpoch(timestamp),
        json['commentContent'] as String,
        Quote(
            json['postHostCommentId'] as int,
            json['postTitle'] as String,
            json['postHostCommentContent'] as String,
            int.parse(json['postHostCommentFloor'] as String)));
  }
}

class FollowRecord {
  UserInfo _userInfo;
  DateTime _time;
  FollowStatus _followStatus;

  UserInfo get userInfo => _userInfo;
  DateTime get time => _time;
  FollowStatus get followStatus => _followStatus;

  FollowRecord(this._userInfo, this._time, this._followStatus);

  factory FollowRecord.fromJson(dynamic json) {
    int timestamp = json['timestamp'] as int;
    return FollowRecord(
        UserInfo(
            json['fromUserUserId'] as int, json['fromUserUserName'] as String,
            avatarUrl: json['fromUserAvatar'] == null ? null : json['fromUserAvatar'] as String
        ),
        DateTime.fromMillisecondsSinceEpoch(timestamp),
        followStatusMap[json['followStatus'] as String]!);
  }
}

class StarRecord {
  UserInfo _userInfo;
  DateTime _time;
  Quote _starredPost;

  UserInfo get userInfo => _userInfo;
  StarRecord(this._userInfo, this._time, this._starredPost);
  DateTime get time => _time;

  Quote get starredPost => _starredPost;

  factory StarRecord.fromJson(dynamic json) {
    int timeStamp = json['timestamp'] as int;
    return StarRecord(
        UserInfo(
            json['fromUserUserId'] as int, json['fromUserUserName'] as String),
        DateTime.fromMillisecondsSinceEpoch(timeStamp),
        Quote(
            json['postHostCommentId'] as int,
            json['postTitle'] as String,
            json['postHostCommentContent'] as String,
            json['postHostCommentFloor'] as int));
  }
}
