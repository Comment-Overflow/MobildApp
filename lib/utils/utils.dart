import 'package:dart_date/dart_date.dart';

/// Convert DateTime to String displayed by Comment Overflow. Eliminate verbose
/// information based on [time].
String getDisplayTime(DateTime time) {
  if (time.isToday)
    return time.format('HH:mm');
  else if (time.isYesterday)
    return '昨天';
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

