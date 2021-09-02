import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class CustomStyles {
  static const highlightedColor = Colors.deepOrangeAccent;
  static const postTitleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    height: 1.3,
  );
  static final highlightedPostTitleStyle =
      postTitleStyle.copyWith(color: highlightedColor);
  static const postFooterStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13.0,
  );
  static const postContentStyle = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    height: 1.3,
  );
  static final highlightedPostContentStyle =
      postContentStyle.copyWith(color: highlightedColor);
  static const postPageTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );
  static const postPageBottomStyle = TextStyle(
    fontSize: 14.0,
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
    fontSize: 13,
    color: Colors.grey,
  );
  static const floorStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 13,
  );

  static const userNameStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16.5,
  );

  static const galleryStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16.5,
  );

  static final highlightedUserNameStyle =
      userNameStyle.copyWith(color: highlightedColor);

  static const jumpPageStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0);

  static const currentPageStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);

  static const otherPageStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black54);

  static const userBriefStyle = TextStyle(
    color: Colors.grey,
  );

  static const commentDeletedStyle = TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  );

  static const postFrozenStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );

  static const pageTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
  );

  static const personalPageUserNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Constants.defaultPersonalPageHeaderTitleSize,
  );
  static const personalPageUserBriefStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13.5,
  );
  static const personalPageButtonNumberStyle = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  static const personalPageButtonTextStyle = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 14.0,
  );

  static const statisticFigureStyle = TextStyle(fontSize: 28.0);

  static const statisticTextStyle = TextStyle(fontSize: 18.0);

  static const profileSettingItemTitleStyle = TextStyle(
      color: Colors.blueGrey, fontWeight: FontWeight.normal, fontSize: 16.0);

  /// Default icon for reply with changeable size.
  static Icon getDefaultReplyIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.text_bubble, color: color, size: size);

  /// Default icon for hot index.
  static Icon getDefaultHotIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.flame_fill, color: color, size: size);

  /// Default icon for thumb up.
  static getDefaultThumbUpIcon({size = 14.0, color = Colors.pinkAccent}) =>
      Icon(CupertinoIcons.heart_fill, color: color, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbUpIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.heart, color: color, size: size);

  static getFreezeIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.lock, color: color, size: size);

  static getReleaseIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.lock_open, color: color, size: size);

  static getDefaultThumbDownIcon({size = 14.0, color = Colors.black87}) =>
      Icon(CupertinoIcons.hand_thumbsdown_fill, color: color, size: size);

  /// Default icon for not thumb up.
  static getDefaultNotThumbDownIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.hand_thumbsdown, color: color, size: size);

  /// Default icon for delete.
  static getDefaultDeleteIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.trash, color: color, size: size);

  /// Default icon for drop down menu.
  static getDefaultArrowDownIcon({size = 14.0, color = Colors.black87}) =>
      Icon(Icons.keyboard_arrow_down, color: color, size: size);

  /// Default icon for star.
  static getDefaultStaredIcon({size = 14.0, color = Colors.amberAccent}) =>
      Icon(CupertinoIcons.star_fill, color: color, size: size);

  /// Default icon for not star.
  static getDefaultNotStarIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.star, color: color, size: size);

  /// Default icon for list.
  static getDefaultListIcon({size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.list_bullet, color: color, size: size);

  /// Default icon for plus.
  static Icon getDefaultPlusIcon({size = 14.0, color = Colors.blue}) =>
      Icon(Icons.add, color: color, size: size);

  /// Default icon for tick.
  static Icon getDefaultTickIcon({size = 14.0, color = Colors.white}) =>
      Icon(Icons.check, color: color, size: size);

  /// Default icon for bidirectional following relationship.
  static Icon getDefaultBidirectionalFollowIcon(
          {size = 12.0, color = Colors.white}) =>
      Icon(CupertinoIcons.arrow_right_arrow_left, color: color, size: size);

  /// Default icon for followers (filled).
  static Icon getDefaultFilledFollowerIcon(
          {size = 14.0, color = Colors.grey}) =>
      Icon(Icons.people_alt, color: color, size: size);

  /// Default icon for followers (unfilled).
  static Icon getDefaultUnfilledFollowerIcon(
          {size = 14.0, color = Colors.grey}) =>
      Icon(CupertinoIcons.person, color: color, size: size);

  static Icon getDefaultBackIcon({size = 14.0, color: Colors.grey}) => Icon(
        Icons.arrow_back,
        color: color,
        size: size,
      );

  static Icon getSilenceIcon({size = 14.0, color: Colors.black87}) => Icon(
        CupertinoIcons.speaker_slash,
        color: color,
        size: size,
      );

  static Icon getFreeIcon({size = 14.0, color: Colors.black87}) => Icon(
        CupertinoIcons.speaker_2,
        color: color,
        size: size,
      );

  static Icon getAdminIcon({size = 14.0, color: Colors.green}) => Icon(
        Icons.verified_user_outlined,
        color: color,
        size: size,
      );

  /// Default icon for female.
  static getDefaultFemaleIcon(
          {size = Constants.defaultPersonalPageHeaderTitleSize,
          color = CustomColors.femalePink}) =>
      Icon(Icons.female, color: color, size: size);

  /// Default icon for male.
  static getDefaultMaleIcon(
          {size = Constants.defaultPersonalPageHeaderTitleSize,
          color = CustomColors.maleBlue}) =>
      Icon(Icons.male, color: color, size: size);

  static Icon getDefaultSendIcon({size = 14.0, color: Colors.grey}) => Icon(
        Icons.send,
        color: color,
        size: size,
      );

  /// Default icon for image.
  static Icon getDefaultImageIcon({size = 14.0, color: Colors.grey}) =>
      Icon(CupertinoIcons.photo, color: color, size: size);

  /// Default icon for close.
  static Icon getDefaultCloseIcon({size = 14.0, color: Colors.grey}) =>
      Icon(Icons.close, color: color, size: size);

  static Icon getDefaultMailIcon({size = 22.0, color = Colors.orangeAccent}) =>
      Icon(Icons.mail_outline, color: color, size: size);

  static Icon getDefaultEditIcon({size = 20.0, color = Colors.black}) =>
      Icon(Icons.edit, color: color, size: size);

  static Icon getDefaultSignOutIcon({size = 20.0, color = Colors.black}) =>
      Icon(Icons.logout, color: color, size: size);

  static Icon getDefaultRightArrow({size = 14.0, color = Colors.grey}) =>
      Icon(Icons.keyboard_arrow_right_sharp, color: color, size: size);

  static Icon getDefaultMessageFailIcon({size = 14.0, color = Colors.red}) =>
      Icon(CupertinoIcons.exclamationmark_circle_fill,
          color: color, size: size);

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

  static const chatMessageTimeStyle =
      TextStyle(fontSize: 11.0, color: Colors.grey);

  static final firstPageErrorIndicator = Container(
      height: 1,
      padding: EdgeInsets.fromLTRB(60, 0, 60, 60),
      child: EmptyWidget(
        image: null,
        packageImage: PackageImage.Image_4,
        title: '网络出错了',
        subTitle: '点击重试',
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 17,
          color: Color(0xffabb8d6),
        ),
        hideBackgroundAnimation: true,
      ));
}
