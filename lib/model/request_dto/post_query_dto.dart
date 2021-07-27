import 'package:comment_overflow/assets/constants.dart';

class PostQueryDTO {
  final PostTag _tag;
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
      {required PostTag tag, required int pageNum, required int pageSize})
      : _tag = tag,
        _pageSize = pageSize,
        _pageNum = pageNum;

  Map<String, dynamic> getData() =>
      {"tag": _tagNames[_tag], "pageNum": _pageNum, "pageSize": _pageSize};
}
