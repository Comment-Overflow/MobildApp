
import 'package:zhihu_demo/model/post.dart';

const _title = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
const _author = 'Cicero\'s De Finibus Bonorum et Malorum';
const _content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

final posts = List<Post>.filled(
    20,
    Post(_title, _author, _content, 500, 1000, '2020-1-1'),
    growable: true,
);