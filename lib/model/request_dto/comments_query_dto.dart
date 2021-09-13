import 'dart:core';

import 'package:comment_overflow/assets/constants.dart';

class CommentQueryDTO {
  final int _postId;
  final SortPolicy _policy;
  final int _pageNum;
  final int _pageSize;

  static final Map<SortPolicy, String> _policyNames = {
    SortPolicy.earliest : "EARLIEST",
    SortPolicy.latest : "LATEST",
    SortPolicy.hottest : "HOTTEST"
  };

  CommentQueryDTO({
    required int postId,
    required SortPolicy policy,
    required int pageNum,
    required int pageSize,
  }) : _postId = postId,
      _policy = policy,
      _pageNum = pageNum,
      _pageSize = pageSize;

  Map<String, dynamic> getData() => {
    "postId" : _postId,
    "policy" : _policyNames[_policy],
    "pageNum" : _pageNum,
    "pageSize" : _pageSize
  };
}