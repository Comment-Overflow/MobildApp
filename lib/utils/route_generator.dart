import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/pages/search_page.dart';
import 'package:zhihu_demo/pages/search_result_page.dart';
import 'package:zhihu_demo/pages/post_page.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';

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
        return MaterialPageRoute(builder: (_) => PostPage(posts[0], comments));
    }
  }
}