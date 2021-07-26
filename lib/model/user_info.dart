import 'package:comment_overflow/assets/constants.dart';

class UserInfo {
  final int _userId;
  final String _userName;
  final String? avatarUrl;

  int get userId => _userId;

  String get userName => _userName;

  // String get avatarUrl => _avatarUrl;

  UserInfo(this._userId, this._userName, {this.avatarUrl});

  factory UserInfo.fromJson(dynamic json) => UserInfo(
        json['id'] as int,
        json['userName'] as String,
        avatarUrl: json['avatarUrl'] as String,
      );
}

class UserCardInfo extends UserInfo {
  final String _brief;
  final int _commentCount;
  final int _followerCount;
  final FollowStatus _followStatus;

  String get brief => _brief;

  int get commentCount => _commentCount;

  int get followerCount => _followerCount;

  FollowStatus get followStatus => _followStatus;

  UserCardInfo(userId, userName, avatarUrl, this._brief, this._commentCount,
      this._followerCount, this._followStatus)
      : super(userId, userName, avatarUrl: avatarUrl);
}

class PersonalPageInfo extends UserCardInfo {
  final Sex _sex;
  final int _approvalCount;
  final int _followingCount;

  Sex get sex => _sex;

  int get approvalCount => _approvalCount;

  int get followingCount => _followingCount;

  PersonalPageInfo(
      userId,
      userName,
      avatarUrl,
      brief,
      commentCount,
      followerCount,
      followStatus,
      this._sex,
      this._approvalCount,
      this._followingCount)
      : super(userId, userName, avatarUrl, brief, commentCount, followerCount,
            followStatus);
}
