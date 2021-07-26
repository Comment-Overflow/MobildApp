import 'package:flutter/cupertino.dart';
import 'package:mutex/mutex.dart';

class GlobalUtils {
  static final GlobalKey<NavigatorState>? _navKey = GlobalKey();

  static GlobalKey<NavigatorState>? get navKey => _navKey;

  static final Mutex _mutex = Mutex();

  static Mutex get mutex => _mutex;
}
