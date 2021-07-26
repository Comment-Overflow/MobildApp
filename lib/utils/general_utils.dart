import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/exceptions/user_unauthorized_exception.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dart_date/dart_date.dart';

class GeneralUtils {
  /// Convert DateTime to String by default. Eliminate verbose
  /// information based on [time].
  static String getDefaultTimeString(DateTime time) {
    if (time.isToday)
      return time.format('HH:mm');
    else if (time.isYesterday)
      return '昨天';
    else if (time.isThisYear)
      return time.format('MM-dd');
    else
      return time.format('yyyy-MM-dd');
  }

  /// Convert int to String by default. Eliminate some least
  /// significant digits if [number] is too large.
  /// For example, number 12345 will be converted to '12.3k'.
  static String getDefaultNumberString(int number) {
    if (number < 1000)
      return number.toString();
    else {
      int hundred = ((number % 1000) / 100).floor();
      int thousand = (number / 1000).floor();
      return thousand.toString() + '.' + hundred.toString() + 'k';
    }
  }

  /// Convert DateTime to String displayed in chat room.
  static String getChatTimeString(DateTime time) {
    if (time.isToday)
      return time.format('HH:mm');
    else if (time.isYesterday)
      return '昨天 ' + time.format('HH:mm');
    else if (time.isThisYear)
      return time.format('MM-dd HH:mm');
    else
      return time.format('yyyy-MM-dd HH:mm');
  }

  /// Get the current JWT token.
  static Future<String> getCurrentToken() async {
    String? token = await StorageUtil().storage.read(key: Constants.token);
    if (token == null) throw UserUnauthorizedException();
    return token;
  }

  /// Get the current user ID.
  static Future<int> getCurrentUserId() async {
    String? userId = await StorageUtil().storage.read(key: Constants.userId);
    if (userId == null) throw UserUnauthorizedException();
    return int.parse(userId);
  }

  static FollowStatus getFollowStatus(String str) {
    switch (str) {
      case 'FOLLOWED_BY_ME':
        return FollowStatus.followedByMe;
      case 'FOLLOWING_ME':
        return FollowStatus.followingMe;
      case 'BOTH':
        return FollowStatus.both;
      case 'NONE':
      default:
        return FollowStatus.none;
    }
  }

  /// Get the message content to display in chat card.
  static String getLastMessageContent(Message message) {
      MessageType type = message.type;
      return type == MessageType.Text ? message.content : Constants
          .imageLastMessage;
  }
}
