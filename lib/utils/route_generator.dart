import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/pages/login_page.dart';
import 'package:comment_overflow/pages/new_post_page.dart';
import 'package:comment_overflow/pages/post_page.dart';
import 'package:comment_overflow/pages/search_page.dart';
import 'package:comment_overflow/pages/search_result_page.dart';
import 'package:comment_overflow/widgets/pages_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const homeRoute = '/';
  static const searchRoute = '/search';
  static const searchResultRoute = '/search_result';
  static const newPostRoute = '/new_post';
  static const loginRoute = '/login';
  static const postRoute = '/post';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case newPostRoute:
        return MaterialPageRoute(builder: (_) => NewPostPage());
      case searchRoute:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case searchResultRoute:
        return MaterialPageRoute(
            builder: (_) => SearchResultPage(args as String));
      case postRoute:
        return MaterialPageRoute(
          builder: (_) => PostPage(args as Post));
      case homeRoute:
      default:
        return MaterialPageRoute(builder: (_) => PagesContainer());
    }
  }
}
