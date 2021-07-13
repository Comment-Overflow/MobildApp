import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomStyles {
  static const postTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static const postFooterStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13,
  );
  static const postContentStyle = TextStyle(
    fontSize: 14,
  );

  /// Default icon for reply with changeable size.
  static Icon getDefaultReplyIcon({size = 14.0}) =>
      Icon(Icons.chat_outlined, color: Colors.grey, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbUpIcon({size = 14.0}) =>
      Icon(Icons.favorite, color: Colors.pink[300], size: size);
}
