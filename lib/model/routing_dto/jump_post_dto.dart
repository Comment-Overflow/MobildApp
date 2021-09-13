import '../post.dart';

class JumpPostDTO {
  Post _post;
  int? _pageIndex;

  Post get post => _post;
  int? get pageIndex => _pageIndex;

  JumpPostDTO(this._post, {pageIndex: 0}) : _pageIndex = pageIndex;
}
