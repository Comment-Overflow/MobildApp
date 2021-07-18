import 'package:intl/intl.dart';

class GeneralUtils {
  static String getTimeString(DateTime time) =>
      DateFormat("yyyy-MM-dd").format(time);
}
