import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/pages/search_page.dart';
import 'package:zhihu_demo/pages/search_result_page.dart';
import 'package:zhihu_demo/widgets/pages_container.dart';

class RouteGenerator {
  static const homeRoute = '/';
  static const searchRoute = '/search';
  static const searchResultRoute = '/search_result';

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case searchRoute:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case searchResultRoute:
        return MaterialPageRoute(
            builder: (_) => SearchResultPage(args as String));
      case homeRoute:
      default:
        return MaterialPageRoute(builder: (_) => PagesContainer());
    }
  }
}