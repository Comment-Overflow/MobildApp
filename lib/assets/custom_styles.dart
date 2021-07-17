import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

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
    fontSize: 15.0,
    color: Colors.grey,
  );
  static const commentContentStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15.0,
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

  static const personalPageUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Constants.defaultPersonalPageHeaderTitleSize,
  );
  static const personalPageButtonNumberStyle = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 23.0,
  );
  static const personalPageButtonTextStyle = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 15.0,
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

  /// Default icon for plus.
  static Icon getDefaultPlusIcon({size = 18.0, color = Colors.blue}) =>
      Icon(Icons.add, color: color, size: size);

  /// Default icon for tick.
  static Icon getDefaultTickIcon({size = 18.0, color = Colors.white}) =>
      Icon(Icons.check, color: color, size: size);

  /// Default icon for bidirectional following relationship.
  static Icon getDefaultBidirectionalFollowIcon(
          {size = 16.0, color = Colors.white}) =>
      Icon(CupertinoIcons.arrow_right_arrow_left, color: color, size: size);

  /// Default icon for followers (filled).
  static Icon getDefaultFilledFollowerIcon(
          {size = 14.0, color = Colors.grey}) =>
      Icon(Icons.people_alt, color: color, size: size);

  /// Default icon for followers (unfilled).
  static Icon getDefaultUnfilledFollowerIcon(
          {size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.person, color: color, size: size);

  static Icon getDefaultBackIcon(context, {size = 14.0}) => Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).accentColor,
        size: size,
      );

  /// Default icon for female.
  static getDefaultFemaleIcon({size = Constants.defaultPersonalPageHeaderTitleSize, color = CustomColors.femalePink}) =>
      Icon(Icons.female, color: color, size: size);

  /// Default icon for male.
  static getDefaultMaleIcon({size = Constants.defaultPersonalPageHeaderTitleSize, color = CustomColors.maleBlue}) =>
      Icon(Icons.male, color: color, size: size);

  static Icon getDefaultSendIcon(context, {size = 14.0}) => Icon(
        Icons.send,
        color: Theme.of(context).accentColor,
        size: size,
      );

  /// Default icon for image.
  static Icon getDefaultImageIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.photo, color: color, size: size);

  /// Default icon for close.
  static Icon getDefaultCloseIcon({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.close, color: color, size: size);

  static Icon getDefaultMailIcon({size = 22.0, color = Colors.blueAccent}) =>
      Icon(Icons.mail_outline, color: color, size: size);

  static Icon getDefaultEditIcon({size = 20.0, color = Colors.black}) =>
      Icon(Icons.edit, color: color, size: size);

  static Icon getDefaultSignOutIcon({size = 20.0, color = Colors.black}) =>
      Icon(Icons.logout, color: color, size: size);

  static Icon getDefaultRightArrow({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.keyboard_arrow_right_sharp, color: color, size: size);

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
