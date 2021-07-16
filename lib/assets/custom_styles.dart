import 'package:flutter/cupertino.dart';
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

  /// Default icon for reply with changeable size.
  static Icon getDefaultReplyIcon({size = 14.0}) =>
      Icon(Icons.chat_outlined, color: Colors.grey, size: size);

  /// Default icon for thumb up.
  static Icon getDefaultThumbUpIcon({size = 14.0}) =>
      Icon(Icons.favorite, color: Colors.pink[300], size: size);

  /// Default icon for plus.
  static Icon getDefaultPlusIcon({size = 18.0}) =>
      Icon(Icons.add, color: Colors.blue, size: size);

  /// Default icon for tick.
  static Icon getDefaultTickIcon({size = 18.0}) =>
      Icon(Icons.check, color: Colors.white, size: size);

  /// Default icon for bidirectional following relationship.
  static Icon getDefaultBidirectionalFollowIcon({size = 16.0}) =>
      Icon(CupertinoIcons.arrow_right_arrow_left,
          color: Colors.white, size: size);

  /// Default icon for followers.
  static Icon getDefaultFollowerIcon({size = 14.0}) =>
      Icon(Icons.people_alt, color: Colors.grey, size: size);

  static Icon getDefaultBackIcon(context, {size = 14.0}) => Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).accentColor,
        size: size,
      );

  static Icon getDefaultSendIcon(context, {size = 14.0}) => Icon(
        Icons.send,
        color: Theme.of(context).accentColor,
        size: size,
      );

  static const referenceUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const referenceContentStyle = TextStyle(
    fontSize: 14.0,
  );
  static const newPostTitleStyle = TextStyle(
    fontSize: 17.0,
  );
}
