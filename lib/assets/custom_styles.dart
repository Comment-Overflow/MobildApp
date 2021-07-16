import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:zhihu_demo/assets/custom_colors.dart';

class CustomStyles {
  static const postTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const postFooterStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13.0,
  );
  static const postContentStyle = TextStyle(
    fontSize: 14.0,
  );
  static const commentContentStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 13,
  );

  static const myCommentContentStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const myCommentPostTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 13,
  );

  static const dateStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: Colors.grey,
  );
  static const floorStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  static const userNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  static const userBriefStyle = TextStyle(
    color: Colors.grey,
  );

  static const lastMessageTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );
  static const unreadChatTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const lastChatTimeTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const pageTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  /// Default icon for reply with changeable size.
  static Icon getDefaultReplyIcon({size = 14.0, color: Colors.grey}) =>
      Icon(CupertinoIcons.text_bubble, color: color, size: size);

  /// Default icon for thumb up.
  static Icon getDefaultThumbUpIcon({size = 14.0, color = CustomColors.thumbUpPink}) =>
      Icon(Icons.favorite, color: color, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbUpIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.favorite_border, color: color, size: size);

  /// Default icon for light not thumb up.
  static getDefaultLightNotThumbUpIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.heart, color: color, size: size);

  /// Default icon for plus.
  static Icon getDefaultPlusIcon({size = 18.0, color = Colors.blue}) =>
      Icon(Icons.add, color: color, size: size);

  /// Default icon for tick.
  static Icon getDefaultTickIcon({size = 18.0, color = Colors.white}) =>
      Icon(Icons.check, color: color, size: size);

  /// Default icon for bidirectional following relationship.
  static Icon getDefaultBidirectionalFollowIcon({size = 16.0, color = Colors.white}) =>
      Icon(CupertinoIcons.arrow_right_arrow_left, color: color, size: size);

  /// Default icon for followers (filled).
  static Icon getDefaultFilledFollowerIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.people_alt, color: color, size: size);

  /// Default icon for followers (unfilled).
  static Icon getDefaultUnfilledFollowerIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.person, color: color, size: size);

  /// Default icon for not star.
  static getDefaultNotStarIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.star, color: color, size: size);

  static const referenceUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const referenceContentStyle = TextStyle(
    fontSize: 14.0,
  );
}
