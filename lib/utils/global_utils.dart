import 'package:flutter/cupertino.dart';

class GlobalUtils {

  static final GlobalKey<NavigatorState>? _navKey = GlobalKey();

  static GlobalKey<NavigatorState>? get navKey => _navKey;

}
