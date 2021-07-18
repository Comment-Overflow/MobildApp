import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/routing_dto/image_gallery_dto.dart';
import 'package:comment_overflow/model/routing_dto/personal_page_access_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/pages/login_page.dart';
import 'package:comment_overflow/pages/new_post_page.dart';
import 'package:comment_overflow/pages/notification_page.dart';
import 'package:comment_overflow/pages/personal_page.dart';
import 'package:comment_overflow/pages/post_page.dart';
import 'package:comment_overflow/pages/profile_setting_page.dart';
import 'package:comment_overflow/pages/scroll_view_page.dart';
import 'package:comment_overflow/pages/search_page.dart';
import 'package:comment_overflow/pages/search_result_page.dart';
import 'package:comment_overflow/widgets/image_gallery.dart';
import 'package:comment_overflow/widgets/my_comment_card_list.dart';
import 'package:comment_overflow/widgets/notification_card_list.dart';
import 'package:comment_overflow/widgets/pages_container.dart';
import 'package:comment_overflow/widgets/post_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const homeRoute = '/';
  static const searchRoute = '/search';
  static const searchResultRoute = '/search_result';
  static const newPostRoute = '/new_post';
  static const loginRoute = '/login';
  static const postRoute = '/post';
  static const profileSettingRoute = '/profile_setting';
  static const galleryRoute = '/gallery';
  static const notificationRoute = '/notification';
  static const personalRoute = '/personal';
  static const approveMeRoute = '/approval';
  static const replyMeRoute = '/comment';
  static const starMeRoute = '/star';
  static const followMeRoute = '/follow';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case approveMeRoute:
        return MaterialPageRoute(
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.approval), '赞同'));
      case replyMeRoute:
        return MaterialPageRoute(
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.reply), '回复'));
      case starMeRoute:
        return MaterialPageRoute(
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.star), '收藏'));
      case followMeRoute:
        return MaterialPageRoute(
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.follow), '关注'));
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
        return MaterialPageRoute(builder: (_) => PostPage(args as Post));
      case profileSettingRoute:
        return MaterialPageRoute(builder: (_) => ProfileSettingPage());
      case galleryRoute:
        return MaterialPageRoute(
            builder: (_) => ImageGallery(
                  imageUrl: (args as ImageGalleryDto).imageUrl,
                  initialIndex: (args).index,
                ));
      case notificationRoute:
        return MaterialPageRoute(builder: (_) => NotificationPage());
      case personalRoute:
        return MaterialPageRoute(builder: (_) {
          final arguments = args as PersonalPageAccessDto;
          return PersonalPage(arguments.userId, arguments.fromCard);
        });
      case homeRoute:
      default:
        return MaterialPageRoute(builder: (_) => PagesContainer());
    }
  }
}
