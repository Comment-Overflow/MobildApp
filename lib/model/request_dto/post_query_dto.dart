import 'package:comment_overflow/assets/constants.dart';

class PostQueryDTO {
  final PostTag? _tag;
  final bool _followingOnly;
  final int _pageNum;
  final int _pageSize;

  static final Map<PostTag, String> _tagNames = {
    PostTag.Life: "LIFE",
    PostTag.Study: "STUDY",
    PostTag.Art: "ART",
    PostTag.Mood: "MOOD",
    PostTag.Career: "CAREER"
  };

  PostQueryDTO(
      {PostTag? tag,
      required int pageNum,
      required int pageSize,
      bool followingOnly: false})
      : _tag = tag,
        _pageSize = pageSize,
        _pageNum = pageNum,
        _followingOnly = followingOnly;

  Map<String, dynamic> getData() => _tag != null
      ? {
          "tag": _tagNames[_tag],
          "pageNum": _pageNum,
          "pageSize": _pageSize,
          "followingOnly": _followingOnly
        }
      : {
          "pageNum": _pageNum,
          "pageSize": _pageSize,
          "followingOnly": _followingOnly
        };
}
