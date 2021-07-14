import 'package:zhihu_demo/model/post.dart';
import 'package:zhihu_demo/model/reference.dart';

const _title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
const _author = 'Cicero\'s De Finibus Bonorum et Malorum';
const _content =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

final posts = List<Post>.filled(
  5,
  Post(_title, _author, _content, 500, 1000, '2020-1-1', null),
  growable: true,
)
  ..addAll(List<Post>.filled(
    5,
    Post(_title, _author, _content, 500, 1000, '2020-1-1',
        "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
    growable: true,
  ))
  ..addAll(List<Post>.filled(
    5,
    Post(_title, _author, _content, 500, 1000, '2020-1-1',
        "https://images.unsplash.com/photo-1526512340740-9217d0159da9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2677&q=80"),
    growable: true,
  ));

final references = List<Reference>.filled(
  20,
  Reference(_author + _author, _content),
  growable: true,
);