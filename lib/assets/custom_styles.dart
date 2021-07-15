import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  static const postPageTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );
  static const postPageBottomStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.grey,
  );
  static const commentContentStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15.0,
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
  /// Default icon for reply with changeable size.
  static Icon getDefaultReplyIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.chat_outlined, color: color, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbUpIcon({size = 14.0, color = Colors.pinkAccent}) =>
      Icon(Icons.favorite, color: color, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbUpIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.favorite_border, color: color, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbDownIcon({size = 14.0, color = Colors.black87}) =>
      Icon(Icons.thumb_down, color: color, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbDownIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.thumb_down_outlined, color: color, size: size);

  /// Default icon for delete.
  static getDefaultDeleteIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.delete_forever, color: color, size: size);

  /// Default icon for drop down menu.
  static getDefaultArrowDownIcon({size = 14.0, color = Colors.black87}) =>
      Icon(Icons.keyboard_arrow_down, color: color, size: size);

  /// Default icon for star.
  static getDefaultStaredIcon({size = 14.0, color = Colors.amberAccent}) =>
      Icon(Icons.star, color: color, size: size);

  /// Default icon for not star.
  static getDefaultNotStarIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.star_border, color: color, size: size);
  
  /// Default icon for list.
  static getDefaultListIcon({size = 14.0, color = Colors.grey}) =>
    Icon(Icons.list, color: color, size: size);

  static const referenceUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const referenceContentStyle = TextStyle(
    fontSize: 14.0,
  );
}
