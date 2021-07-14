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
  static Icon getDefaultReplyIcon({size = 14.0}) =>
      Icon(Icons.chat_outlined, color: Colors.grey, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbUpIcon({size = 14.0}) =>
      Icon(Icons.favorite, color: Colors.pink[300], size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbUpIcon({size = 14.0}) =>
      Icon(Icons.favorite_border, color: Colors.grey, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbDownIcon({size = 14.0}) =>
      Icon(Icons.thumb_down, color: Colors.black87, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbDownIcon({size = 14.0}) =>
      Icon(Icons.thumb_down_outlined, color: Colors.grey, size: size);

  /// Default icon for delete.
  static getDefaultDeleteIcon({size = 14.0}) =>
      Icon(Icons.delete_forever, color: Colors.grey, size: size);

  static const referenceUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const referenceContentStyle = TextStyle(
    fontSize: 14.0,
  );
}
