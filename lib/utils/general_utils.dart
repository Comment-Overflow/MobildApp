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
}
