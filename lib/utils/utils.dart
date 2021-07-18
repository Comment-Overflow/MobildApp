import 'package:dart_date/dart_date.dart';

/// Convert DateTime to String displayed by most pages of Comment
/// Overflow. Eliminate verbose information based on [time].
String getDisplayTime(DateTime time) {
  if (time.isToday)
    return time.format('HH:mm');
  else if (time.isYesterday)
    return '昨天';
  else if (time.isThisYear)
    return time.format('MM-dd');
  else
    return time.format('yyyy-MM-dd');
}

/// Convert int to String displayed by Comment Overflow. Eliminate some least
/// significant digits if the number is too large.
String getDisplayNumber(int number) {
  if (number < 1000)
    return number.toString();
  else {
    int hundred = ((number % 1000) / 100).floor();
    int thousand = (number / 1000).floor();
    return thousand.toString() + '.' + hundred.toString() + 'k';
  }
}

/// Convert DateTime to String displayed in chat room.
String getChatTime(DateTime time) {
  if (time.isToday)
    return time.format('HH:mm');
  else if (time.isYesterday)
    return '昨天 ' + time.format('HH:mm');
  else if (time.isThisYear)
    return time.format('MM-dd HH:mm');
  else
    return time.format('yyyy-MM-dd HH:mm');
}

