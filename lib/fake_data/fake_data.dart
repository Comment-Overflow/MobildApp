import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/model/quote.dart';
import 'package:zhihu_demo/model/user_info.dart';

const _title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
const _author = 'Gun9niR';
const _content =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

final _date = DateTime(2020);
final UserInfo _userInfo = UserInfo(0, "Gun9niR", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserCardInfo _userCardInfo = UserCardInfo(
    _userInfo.userId, _userInfo.userName, _userInfo.avatarUrl,
    "This is a long long long long long long long long long long long description", 
    12, 23567, FollowStatus.followedByMe);
final Quote _quote = Quote("Gun9niR", _content);
final Comment _approvedComment = Comment(_userInfo, _content, _date, _quote, 0, 500, ApprovalStatus.approve, []);
final Comment _disapprovedComment = Comment(_userInfo, _content, _date, _quote, 0, 500, ApprovalStatus.approve, ["http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg", "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"]);
final Comment _noneComment = Comment(_userInfo, _content, _date, _quote, 0, 500, ApprovalStatus.none, ["https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"]);

final posts = List<Post>.filled(
  5,
  Post(1, _title, 500, 300, _approvedComment,),
  growable: true,
)
  ..addAll(List<Post>.filled(
    5,
    Post(1, _title, 500, 700, _disapprovedComment,),
    growable: true,
  ))
  ..addAll(List<Post>.filled(
    5,
    Post(1, _title, 500, 1000, _noneComment,),
    growable: true,
  ));

final quotes = List<Quote>.filled(
  20,
  Quote(_author, _content),
  growable: true,
);

final users = List<UserCardInfo>.filled(
  2,
  UserCardInfo(
      _userInfo.userId, "江湖骗子", _userInfo.avatarUrl,
      "This is a long long long long long long long long long long long description",
      12, 23567, FollowStatus.followedByMe,),
  growable: true,
)
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
        _userInfo.userId, "很长很长很长很长很长很长的用户名", _userInfo.avatarUrl,
        "这是一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长的个人描述",
        12, 23567, FollowStatus.followingMe,),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
        _userInfo.userId, "xx01cyx", _userInfo.avatarUrl,
        "This is a long long long long long long long long long long long description",
        12, 23567, FollowStatus.both,),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
        _userInfo.userId, _userInfo.userName, _userInfo.avatarUrl,
        "This is a long long long long long long long long long long long description",
        12, 23567, FollowStatus.none,),
    growable: true,
  ));