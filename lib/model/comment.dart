import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/general_utils.dart';

class Comment {
  final int _id;
  final UserInfo user;
  final String _content;
  final DateTime _time;
  final Quote? _quote;
  final int _floor;
  int _approvalCount;
  ApprovalStatus _approvalStatus;
  List<String> _imageUrl;

  int get id => _id;
  String get content => _content;
  DateTime get time => _time;
  String get timeString => GeneralUtils.getDefaultTimeString(_time);
  Quote? get quote => _quote;
  int get floor => _floor;
  String get floorString => _floor.toString();
  int get approvalCount => _approvalCount;
  ApprovalStatus get approvalStatus => _approvalStatus;
  List<String> get imageUrl => _imageUrl;

  Comment(this._id, this.user, this._content, this._time, this._quote,
      this._floor, this._approvalCount, this._approvalStatus, this._imageUrl);

  factory Comment.fromJson(dynamic json) {
    var _imageList = json['imageUrl'];
    String statusString = json['approvalStatus'] as String;

    ApprovalStatus status;
    if (statusString == "APPROVAL")
      status = ApprovalStatus.approve;
    else if (statusString == "DISAPPROVAL")
      status = ApprovalStatus.disapprove;
    else
      status = ApprovalStatus.none;

    print(json);
    return Comment(
        json['id'] as int,
        UserInfo.fromJson(json['userInfo']),
        json['content'] as String,
        DateTime.parse(json['time'] as String),
        (json['quoteId'] as int) == 0 ? null : Quote.fromJson(json['quoteDTO']),
        json['floor'] as int,
        json['approvalCount'] as int,
        status,
        _imageList == null ? [] : List.from(_imageList));
  }

  void addApprovals() {
    switch (_approvalStatus) {
      case ApprovalStatus.approve:
        break;
      case ApprovalStatus.disapprove:
        _approvalStatus = ApprovalStatus.none;
        break;
      case ApprovalStatus.none:
        _approvalStatus = ApprovalStatus.approve;
        ++_approvalCount;
        break;
    }
  }

  void subApprovals() {
    switch (_approvalStatus) {
      case ApprovalStatus.disapprove:
        break;
      case ApprovalStatus.approve:
        _approvalStatus = ApprovalStatus.none;
        --_approvalCount;
        break;
      case ApprovalStatus.none:
        _approvalStatus = ApprovalStatus.disapprove;
        break;
    }
  }
}
