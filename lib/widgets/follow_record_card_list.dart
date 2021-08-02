import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/notification_service.dart';
import 'package:comment_overflow/utils/paging_manager.dart';
import 'package:comment_overflow/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';

class FollowRecordCardList extends StatefulWidget {
  final FollowStatus _followStatus;
  const FollowRecordCardList(this._followStatus, {Key? key}) : super(key: key);

  @override
  _FollowRecordCardListState createState() =>
      _FollowRecordCardListState(_followStatus);
}

class _FollowRecordCardListState extends State<FollowRecordCardList> {
  late PagingManager<UserCardInfo> _pagingManager;

  _FollowRecordCardListState(followStatus) {
    String url = '';
    switch (followStatus) {
      case FollowStatus.followingMe:
        url = '/records/following';
        break;
      case FollowStatus.followedByMe:
        url = '/records/followed';
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
    }, _itemBuilder);
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
