import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/exceptions/user_unauthorized_exception.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dart_date/dart_date.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GeneralUtils {
  /// Convert DateTime to String by default. Eliminate verbose
  /// information based on [time].
  static String getDefaultTimeString(DateTime time) {
    DateTime localTime = time.toLocalTime;
    if (localTime.isToday)
      return localTime.format('HH:mm');
    else if (localTime.isYesterday)
      return '昨天';
    else if (localTime.isThisYear)
      return localTime.format('MM-dd');
    else
      return localTime.format('yyyy-MM-dd');
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
    DateTime localTime = time.toLocalTime;
    if (localTime.isToday)
      return localTime.format('HH:mm');
    else if (localTime.isYesterday)
      return '昨天 ' + localTime.format('HH:mm');
    else if (localTime.isThisYear)
      return localTime.format('MM-dd HH:mm');
    else
      return localTime.format('yyyy-MM-dd HH:mm');
  }

  /// Convert number of unread messages into string that displayed in badge.
  /// Returns null if [unreadCount] is 0,
  static String? getBadgeString(int unreadCount) {
    if (unreadCount == 0) return null;
    if (unreadCount > 99) return "99+";
    return unreadCount.toString();
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
        return FollowStatus.followedByCurrentUser;
      case 'FOLLOWING_ME':
        return FollowStatus.followingCurrentUser;
      case 'BOTH':
        return FollowStatus.both;
      case 'NONE':
      default:
        return FollowStatus.none;
    }
  }

  static Future<List<int>> checkImageSize(List<AssetEntity> images) async {
    List<int> indices = List.empty(growable: true);
    int index = 0;
    for (final image in images) {
      if ((await image.file)!.lengthSync() > Constants.sizeLimitBytes) {
        indices.add(index++);
      }
    }
    return indices;
  }

  static String buildOverSizeAlert(List<int> indices) {
    StringBuffer buffer = StringBuffer();
    buffer.write('第');

    int i = 0;
    int length = indices.length;

    for (int index in indices) {
      ++i;
      buffer.write(index + 1);
      if (i != length) buffer.write(', ');
    }
    buffer.write('张图片超过大小限制 (${Constants.sizeLimitMB.floor()}MB)');

    return buffer.toString();
  }

  static String getThumbnailPath(String originalPath) =>
      originalPath.substring(0, originalPath.lastIndexOf(".")) +
      "-tbn" +
      originalPath.substring(originalPath.lastIndexOf("."));
}
