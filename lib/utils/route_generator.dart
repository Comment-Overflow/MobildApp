import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/pages/search_page.dart';
import 'package:zhihu_demo/widgets/pages_container.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchPage());
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => PagesContainer());
    }
  }
}