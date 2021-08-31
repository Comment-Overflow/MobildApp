import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/skeleton/skeleton_user_list.dart';
import 'package:comment_overflow/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';

class FollowRecordCardList extends StatefulWidget {
  final FollowStatus _followStatus;
  final int _userId;
  const FollowRecordCardList(this._followStatus, this._userId,{Key? key}) : super(key: key);

  @override
  _FollowRecordCardListState createState() =>
      _FollowRecordCardListState(_followStatus, _userId);
}

class _FollowRecordCardListState extends State<FollowRecordCardList> {
  late PagingManager<UserCardInfo> _pagingManager;

  _FollowRecordCardListState(followStatus, userId) {
    String url = '';
    switch (followStatus) {
      case FollowStatus.followingCurrentUser:
        url = '/records/following/$userId';
        break;
      case FollowStatus.followedByCurrentUser:
        url = '/records/followed/$userId';
        break;
      default:
        throw 'unsupported follow status for profile page\'s follow records';
    }
    var _itemBuilder = (context, item, index) => UserCard(item);
    _pagingManager = PagingManager((Constants.defaultNotificationPageSize),
        (page, pageSize) async {
      var jsonArray =
          (await NotificationService.getNotification(page, pageSize, url))
              .data['content'] as List;
      return jsonArray.map((json) => UserCardInfo.fromJson(json)).toList();
    }, _itemBuilder,
        firstPageIndicator: SkeletonUserList(),
        emptyIndicatorTitle: followStatus == FollowStatus.followingMe
            ? Constants.noFansIndicatorTitle
            : Constants.noFollowingIndicatorTitle);
  }

  @override
  dispose() {
    _pagingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingManager.getListView();
  }
}
