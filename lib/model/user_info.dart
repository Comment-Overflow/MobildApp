import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/utils/general_utils.dart';

class UserInfo {
  final int _userId;
  final String _userName;
  final String? avatarUrl;

  int get userId => _userId;

  String get userName => _userName;

  UserInfo(this._userId, this._userName, {this.avatarUrl});
  factory UserInfo.fromJson(dynamic json) => UserInfo(
        json['id'] as int,
        json['userName'] as String,
        avatarUrl: json['avatarUrl'] as String,
      );
}

class UserCardInfo extends UserInfo {
  final String? _brief;
  final int _postCount;
  final int _followerCount;
  final FollowStatus _followStatus;

  String get brief => _brief == null ? '' : _brief.toString();

  int get postCount => _postCount;

  int get followerCount => _followerCount;

  FollowStatus get followStatus => _followStatus;

  UserCardInfo(userId, userName, avatarUrl, this._brief, this._postCount,
      this._followerCount, this._followStatus)
      : super(userId, userName, avatarUrl: avatarUrl);

  UserCardInfo.fromJson(Map<String, dynamic> json)
      : _brief = json['brief'],
        _postCount = json['commentCount'],
        _followerCount = json['followerCount'],
        _followStatus = GeneralUtils.getFollowStatus(json['followStatus']),
        super(json['userId'], json['userName'], avatarUrl: json['avatarUrl']);
}

class PersonalPageInfo extends UserCardInfo {
  final Gender _gender;
  final int _approvalCount;
  final int _followingCount;

  Gender get gender => _gender;

  int get approvalCount => _approvalCount;

  int get followingCount => _followingCount;

  PersonalPageInfo(
      userId,
      userName,
      avatarUrl,
      brief,
      postCount,
      followerCount,
      followStatus,
      this._gender,
      this._approvalCount,
      this._followingCount)
      : super(userId, userName, avatarUrl, brief, postCount, followerCount,
            followStatus);

  factory PersonalPageInfo.fromJson(dynamic json) => PersonalPageInfo(
      json['userId'] as int, json['userName'] as String, json['avatarUrl'] as String,
      json['brief'] as String, json['userStatisticPostCount'] as int, json['userStatisticFollowerCount'] as int,
      followStatusMap[json['followStatus'] as String], genderMap[json['gender'] as String]!, json['userStatisticApprovalCount'] as int,
      json['userStatisticFollowingCount'] as int
  );
}
