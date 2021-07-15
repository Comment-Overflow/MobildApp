import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/pages/post_page.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => PostPage(posts[0], comments));
    }
  }
}