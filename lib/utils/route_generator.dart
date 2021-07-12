import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/widgets/pages_container.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => PagesContainer());
    }
  }
}