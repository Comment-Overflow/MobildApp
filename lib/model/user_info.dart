import 'package:zhihu_demo/assets/constants.dart';

class UserInfo {
  final int _userId;
  final String _userName;
  final String _avatarUrl;

  int get userId => _userId;
  String get userName => _userName;
  String get avatarUrl => _avatarUrl;

  UserInfo(this._userId, this._userName, this._avatarUrl);
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
      this._followerCount, this._followStatus) :
        super(userId, userName, avatarUrl);
}

class PersonalPageInfo extends UserInfo {
  final Sex _sex;
  final String _brief;
  final int _commentCount;
  final int _approvalCount;
  final int _followerCount;
  final int _followedCount;

  Sex get sex => _sex;
  String get brief => _brief;
  int get commentCount => _commentCount;
  int get approvalCount => _approvalCount;
  int get followerCount => _followerCount;
  int get followedCount => _followedCount;

  PersonalPageInfo(userId, userName, avatarUrl, this._sex, this._brief,
      this._commentCount, this._approvalCount, this._followerCount,
      this._followedCount) : super(userId, userName, avatarUrl);
}
