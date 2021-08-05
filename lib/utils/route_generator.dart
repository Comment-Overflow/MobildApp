import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/routing_dto/image_gallery_dto.dart';
import 'package:comment_overflow/model/routing_dto/jump_post_dto.dart';
import 'package:comment_overflow/model/routing_dto/personal_page_access_dto.dart';
import 'package:comment_overflow/model/routing_dto/profile_setting_dto.dart';
import 'package:comment_overflow/model/routing_dto/user_name_id_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/pages/intro_page.dart';
import 'package:comment_overflow/pages/login_page.dart';
import 'package:comment_overflow/pages/new_post_page.dart';
import 'package:comment_overflow/pages/notification_page.dart';
import 'package:comment_overflow/pages/personal_page.dart';
import 'package:comment_overflow/pages/post_page.dart';
import 'package:comment_overflow/pages/private_chat_page.dart';
import 'package:comment_overflow/pages/profile_setting_page.dart';
import 'package:comment_overflow/pages/scroll_view_page.dart';
import 'package:comment_overflow/pages/search_page.dart';
import 'package:comment_overflow/pages/search_result_page.dart';
import 'package:comment_overflow/pages/statistic_page.dart';
import 'package:comment_overflow/widgets/follow_record_card_list.dart';
import 'package:comment_overflow/widgets/image_gallery.dart';
import 'package:comment_overflow/widgets/notification_card_list.dart';
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
  static const profileSettingRoute = '/profile_setting';
  static const galleryRoute = '/gallery';
  static const notificationRoute = '/notification';
  static const personalRoute = '/personal';
  static const approveMeRoute = '/approval';
  static const replyMeRoute = '/comment';
  static const starMeRoute = '/star';
  static const privateChatRoute = '/private_chat';
  static const statisticRoute = '/statistic';

  /// Shows the list of notification when other users have followed me.
  static const followMeNotificationRoute = '/follow';
  static const followersRoute = '/followers';
  static const fansRoute = '/fans';
  static const introRoute = '/intro';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case fansRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ScrollViewPage(
              FollowRecordCardList(FollowStatus.followingMe),
              (args as UserNameIdDto).userName + '的粉丝'),
        );
      case followersRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScrollViewPage(
                FollowRecordCardList(FollowStatus.followedByMe),
                (args as UserNameIdDto).userName + '的关注'));
      case approveMeRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.approval), '赞同'));
      case replyMeRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.reply), '回复'));
      case starMeRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.star), '收藏'));
      case followMeNotificationRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ScrollViewPage(
                NotificationCardList(UserActionType.follow), '关注'));
      case loginRoute:
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginPage());
      case newPostRoute:
        return MaterialPageRoute(
            settings: settings, builder: (_) => NewPostPage());
      case searchRoute:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SearchPage());
      case searchResultRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SearchResultPage(args as String));
      case postRoute:
        {
          JumpPostDTO jumpPostDTO = args as JumpPostDTO;
          return MaterialPageRoute(
              builder: (_) => PostPage(
                    jumpPostDTO.post,
                    pageIndex: jumpPostDTO.pageIndex,
                  ));
        }
      case profileSettingRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProfileSettingPage(args as ProfileSettingDto));
      case galleryRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ImageGallery(
                  imageUrl: (args as ImageGalleryDto).imageUrl,
                  initialIndex: (args).index,
                ));
      case notificationRoute:
        return MaterialPageRoute(
            settings: settings, builder: (_) => NotificationPage());
      case personalRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              final arguments = args as PersonalPageAccessDto;
              return PersonalPage(arguments.userId, arguments.displayBack);
            });
      case privateChatRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => PrivateChatPage(args as UserInfo));
      case homeRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                PagesContainer(defaultIndex: args == null ? 0 : args as int));
      case statisticRoute:
        return MaterialPageRoute(builder: (_) => StatisticPage());
      case introRoute:
      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => IntroPage());
    }
  }
}
