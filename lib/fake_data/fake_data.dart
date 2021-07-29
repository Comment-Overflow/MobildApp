import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:comment_overflow/model/comment.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/my_comment.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/model/user_action_record.dart';
import 'package:comment_overflow/model/user_info.dart';

const _title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
const _author = 'Gun9niR';
const _content =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

const int currentUserId = 0;

final _date = DateTime(2020);
final UserInfo _userInfo = UserInfo(
    0, "Gun9niR", avatarUrl: "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _cyxInfo = UserInfo(
    1, "xx01cyx", avatarUrl: "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _yzyInfo = UserInfo(
    2, "JolyneFr", avatarUrl: "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserInfo _wxpInfo = UserInfo(
    3, "WindowsXp", avatarUrl: "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg");
final UserCardInfo _userCardInfo = UserCardInfo(
    _userInfo.userId,
    _userInfo.userName,
    _userInfo.avatarUrl,
    "This is a long long long long long long long long long long long description",
    12,
    23567,
    FollowStatus.followedByMe);
final PersonalPageInfo personalPageInfo = PersonalPageInfo(
    0,
    // "很长的十个字的用户名",
    "Gun9niR",
    "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
    "这是一段三十个字的个人简介！！这是一段三十个字的个人简介！！",
    // "I want a simple life.",
    12,
    23567,
    FollowStatus.none,
    Gender.male,
    128538,
    21);
final Quote _quoteWithUserName = Quote(4, "Gun9niR", "aa", 2);
final Quote _quoteWithPostTitle = Quote(5, "Gun9niR", "aa", 5);

final Comment _approvedComment = Comment(6, _userInfo, "sadad", _date,
    _quoteWithUserName, 0, 500, ApprovalStatus.approve, []);
final Comment _disapprovedComment = Comment(7, _userInfo, _content, _date,
    _quoteWithUserName, 0, 500, ApprovalStatus.approve, [
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
  "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"
]);

final Comment _firstFloorComment = Comment(8, _userInfo, _content, _date,
    _quoteWithUserName, 0, 500, ApprovalStatus.none, [
  "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
]);
final Comment _noneComment = Comment(9, _userInfo, _content, _date,
    _quoteWithUserName, 1, 500, ApprovalStatus.none, [
  "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
  "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
]);

final myComments = List<MyComment>.filled(
  20,
  MyComment(
      _title, _content, "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
  growable: true,
);

final posts = List<Post>.filled(
  10,
  Post(
    1,
    _title,
    500,
    300,
    _approvedComment,
    false
  ),
  growable: true,
)
  ..addAll(List<Post>.filled(
    10,
    Post(
      1,
      _title,
      500,
      700,
      _disapprovedComment,
      false
    ),
    growable: true,
  ))
  ..addAll(List<Post>.filled(
    10,
    Post(
      1,
      _title,
      500,
      1000,
      _noneComment,
      false
    ),
    growable: true,
  ));

final quotes = List<Quote>.filled(
  20,
  Quote(10, _author, _content, 6),
  growable: true,
);

final users = List<UserCardInfo>.filled(
  2,
  UserCardInfo(
    3,
    "江湖骗子",
    _userInfo.avatarUrl,
    "This is a long long long long long long long long long long long description",
    12,
    23567,
    FollowStatus.followedByMe,
  ),
  growable: true,
)
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      4,
      "很长很长很长很长很长很长的用户名",
      _userInfo.avatarUrl,
      "这是一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长的个人描述",
      12,
      23567,
      FollowStatus.followingMe,
    ),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      5,
      "xx01cyx",
      _userInfo.avatarUrl,
      "This is a long long long long long long long long long long long description",
      12,
      23567,
      FollowStatus.both,
    ),
    growable: true,
  ))
  ..addAll(List<UserCardInfo>.filled(
    2,
    UserCardInfo(
      _userInfo.userId,
      _userInfo.userName,
      _userInfo.avatarUrl,
      "This is a long long long long long long long long long long long description",
      12,
      23567,
      FollowStatus.none,
    ),
    growable: true,
  ));

final comments = [_firstFloorComment]..addAll(List<Comment>.filled(
    5,
    _noneComment,
    growable: true,
  )..addAll(List<Comment>.filled(5, _approvedComment, growable: true)));
// Tags for posts
final List<String> tags = ['校园生活', '学在交大', '文化艺术', '心情驿站', '职业发展'];

final recentChats = List<Chat>.filled(
  3,
  Chat(_cyxInfo, "Hi", DateTime.now(), 2),
  growable: true,
)
  ..addAll(List<Chat>.filled(
    3,
    Chat(_cyxInfo, "Very long long long long long long long long message",
        DateTime(2021, 7, 18, 21, 3), 0),
    growable: true,
  ))
  ..addAll(List<Chat>.filled(
    3,
    Chat(_cyxInfo, "很长很长很长很长很长很长很长很长很长很长很长很长很长的中文消息", DateTime(2020), 3),
    growable: true,
  ));

List<Message> messages = [
  Message(MessageType.Text, DateTime.now(), _cyxInfo, _userInfo, "好问题"),
  Message(MessageType.Image, DateTime.now(), _userInfo, _cyxInfo,
      "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
  Message(MessageType.Text, DateTime.now(), _userInfo, _cyxInfo,
      "中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥中午吃啥"),
];

final approvalRecords = List<ApprovalRecord>.filled(
    10,
    ApprovalRecord(
      _yzyInfo,
      _date,
      _quoteWithPostTitle,
    ));

final starRecords = List<StarRecord>.filled(
  10,
  StarRecord(
    _yzyInfo,
    _date,
    _quoteWithPostTitle,
  ),
);

final followRecords = List<FollowRecord>.filled(
  10,
  FollowRecord(
    _yzyInfo,
    _date,
    FollowStatus.followingMe,
  ),
);
