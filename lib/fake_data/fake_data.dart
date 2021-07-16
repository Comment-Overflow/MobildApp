import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/chat.dart';
import 'package:zhihu_demo/model/comment.dart';
import 'package:zhihu_demo/model/message.dart';
import 'package:zhihu_demo/model/my_comment.dart';
import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/model/quote.dart';
import 'package:zhihu_demo/model/user_info.dart';
import 'package:zhihu_demo/model/notification_message.dart';

const _title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
const _author = 'Gun9niR';
const _content =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

const int currentUserId = 1;

final _date = DateTime(2020);
final UserInfo _cyxInfo = UserInfo(0, "xx01cyx", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _gzdInfo = UserInfo(1, "Gun9niR", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _yzyInfo = UserInfo(2, "JolyneFr", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _wxpInfo = UserInfo(3, "WindowsXp", "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserCardInfo _userCardInfo = UserCardInfo(
    _cyxInfo.userId, _cyxInfo.userName, _cyxInfo.avatarUrl,
    "This is a long long long long long long long long long long long description", 
    12, 23567, FollowStatus.followedByMe);
final Quote _quote = Quote("Gun9niR", _content);
final Comment _approvedComment = Comment(_cyxInfo, _content, _date, _quote, 0, 500, ApprovalStatus.approve, []);
final Comment _disapprovedComment = Comment(_cyxInfo, _content, _date, _quote, 0, 500, ApprovalStatus.approve, ["http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg", "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"]);
final Comment _noneComment = Comment(_cyxInfo, _content, _date, _quote, 0, 500, ApprovalStatus.none, ["https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"]);

const _comment = 'zhihu sucks, sjtu-zhihu awesome';
const _type = NotificationType.reply;

final notifications = List<NotificationMessage>.filled(
  20,
  NotificationMessage(_cyxInfo, 24.0, 7.0, _type,
      comment: _comment, title: _title),
  growable: true,
);

final myComments = List<MyComment>.filled(
  20,
  MyComment(_title, _content, "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
  growable: true,
);

final posts = List<Post>.filled(
  10,
  Post(1, _title, 500, 300, _approvedComment,),
  growable: true,
)
  ..addAll(List<Post>.filled(
    10,
    Post(1, _title, 500, 700, _disapprovedComment,),
    growable: true,
  ))
  ..addAll(List<Post>.filled(
    10,
    Post(1, _title, 500, 1000, _noneComment,),
    growable: true,
  ));

final quotes = List<Quote>.filled(
  20,
  Quote(_author, _content),
  growable: true,
);

// Max length 20.
final searchHistory = List<String>.filled(20, "aaaaaaaaaaaaaaaaaaaaaaaaaaaa");

final users = List<UserCardInfo>.filled(
  2,
  UserCardInfo(
    _cyxInfo.userId, "江湖骗子", _cyxInfo.avatarUrl,
      "This is a long long long long long long long long long long long description",
      12, 23567, FollowStatus.followedByMe,),
  growable: true,
)
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      _cyxInfo.userId, "很长很长很长很长很长很长的用户名", _cyxInfo.avatarUrl,
        "这是一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长的个人描述",
        12, 23567, FollowStatus.followingMe,),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      _cyxInfo.userId, "xx01cyx", _cyxInfo.avatarUrl,
        "This is a long long long long long long long long long long long description",
        12, 23567, FollowStatus.both,),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      _cyxInfo.userId, _cyxInfo.userName, _cyxInfo.avatarUrl,
        "This is a long long long long long long long long long long long description",
        12, 23567, FollowStatus.none,),
    growable: true,
  ));

final recentChats = List<Chat>.filled(
  3, Chat(_cyxInfo, "Hi", DateTime.now(), 2), growable: true,
)
  ..addAll(List<Chat>.filled(
    3, Chat(_cyxInfo, "You look good today", DateTime(2021, 7, 14, 21, 3), 0), growable: true,
  ))
  ..addAll(List<Chat>.filled(
    3, Chat(_cyxInfo, "Very long long long long long long long long message", DateTime(2021), 3), growable: true,
  ));

List<Message> messages = [
  Message(MessageType.Text, DateTime.now(), _gzdInfo, _cyxInfo, true, "中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥"),
  Message(MessageType.Text, DateTime.now(), _cyxInfo, _gzdInfo, true, "好问题"),
  Message(MessageType.Image, DateTime.now(), _gzdInfo, _cyxInfo, true, "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
];