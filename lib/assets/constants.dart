class Constants {
  static const int int32MaxValue = 2147483647;

  /// Default page size of pageable list.
  static const defaultPageSize = 8;

  /// Default page size of notification page list.
  static const defaultNotificationPageSize = 10;

  /// Default padding of any card component.
  static const defaultCardPadding = 14.0;

  /// Default size height of a user card.
  static const defaultUserCardHeight = 100.0;

  /// Default padding of a button.
  static const defaultButtonPadding = 5.0;

  /// Default size of Avatar in commentCard.
  static const defaultAvatarInCommentSize = 30.0;

  /// Default size of buttons in notification page.
  static const defaultNotificationButtonSize = 32.0;

  /// Default size height of a chat card.
  static const defaultChatCardHeight = 80.0;

  /// Default size of chat avatar.
  static const defaultChatListAvatarSize = 50.0;

  static const defaultAppBarElevation = 0.5;

  static const defaultCardElevation = 0.5;

  /// Search bar height.
  static const searchBarHeight = 32.0;

  /// Maximum characters for post title.
  static const postTitleMaximumLength = 30;

  static const postContentMaximumLength = 300;

  static const chatListBaselineSize = 15.8;

  /// Default size of avatar in chat room.
  static const defaultChatRoomAvatarSize = 50.0;

  /// Default left padding of avatar in chat room.
  static const defaultChatRoomAvatarPadding = 5.0;

  /// Default vertical padding of chat message.
  static const defaultChatMessagePadding = 4.0;

  /// Default font size in chat room.
  static const defaultChatRoomFontSize = 14.0;

  /// Default max chat bubble width.
  static const defaultMaxBubbleWidth = 200.0;

  /// Default chat room padding.
  static const defaultChatRoomPadding = 10.0;

  /// Default personal page header height.
  static const defaultPersonalPageHeaderHeight = 150.0;

  /// Default personal page avatar size.
  static const defaultPersonalPageAvatarSize = 115.0;

  /// Default personal page avatar padding.
  static const defaultPersonalPageAvatarPadding = 5.0;

  /// Default sex icon size on personal page.
  static const defaultPersonalPageHeaderTitleSize = 22.0;

  /// Default size of personal page header footer text.
  static const defaultPersonalPageHeaderFooterSize = 14.0;

  /// Default personal page header padding.
  static const defaultPersonalPageHeaderHorizontalPadding = 20.0;

  /// Default personal page header padding.
  static const defaultPersonalPageVerticalPadding = 10.0;

  /// Default floating action button size.
  static const defaultFabIconSize = 30.0;

  static const defaultTextButtonHeight = 28.0;

  static const defaultTextButtonPadding = 8.0;

  static const defaultButtonTextSize = 12.0;

  static const chatTimeHorizontalPadding = 8.0;

  static const chatTimeVerticalPadding = 3.0;

  /// Max image number of a comment.
  static const maxImageNumber = 9;

  /// image size of UserAvatar for profile setting page
  static const profileSettingImageSize = 130.0;

  static const profileSettingFontSize = 16.0;

  static const messageBoxFontSize = 16.0;

  /// Default nine-pattern spacing.
  static const defaultNinePatternSpacing = 6.0;

  static const defaultHighlightTime = 2000;

  /// Default page size when getting chat history from backend.
  static const HTTPChatHistoryPage = 15;

  static const maxSearchHistory = 20;

  static const postCommentTimeout = 30;

  static const sizeLimitBytes = 20 * 1024 * 1024;

  static final sizeLimitMB = sizeLimitBytes / 1024 / 1024;

  static final fadeTransitionDuration = 1200;

  // Categories of posts
  static const List<String> postCategories = [
    '????????????',
    '????????????',
    '????????????',
    '????????????',
    '????????????'
  ];

  // Texts of sorter in personal page
  static const List<String> sorterTexts = [
    '???????????????',
    '???????????????',
    '???????????????',
  ];

  static const List<String> personalPageTabs = ["????????????", "????????????", "????????????"];

  static const List<String> statisticPageTabs = ["??????", "??????", "??????", "??????"];

  static const List<String> statistics = [
    "?????????",
    "?????????",
    "???????????????",
    "????????????",
    "?????????",
    "?????????"
  ];

  static const String emailToken = 'emailToken';

  static const String token = 'token';

  static const String userId = 'userId';

  static const String userName = 'userName';

  static const String avatarUrl = 'avatarUrl';

  static const String searchHistory = 'searchHistory';

  static const String userType = 'userType';

  static const String imageLastMessage = '[??????]';

  static const String imageLoadingError = '??????????????????';

  static const String imageReloadPrompt = '??????????????????';

  static const String networkError = '????????????';

  static const String searchCommentEmptyIndicatorTitle = '???????????????';

  static const String searchCommentEmptyIndicatorSubtitle = '????????????????????????';

  static const String searchUserEmptyIndicatorTitle = '???????????????';

  static const String searchUserEmptyIndicatorSubtitle = '????????????????????????';

  static const String commentEmptyIndicatorTitle = "???????????????";

  static const String browsePostIndicatorTitle = '???????????????';

  static const String browsePostEmptyIndicatorSubtitle = '?????????????????????????????????';

  static const String noFansIndicatorTitle = "???????????????";

  static const String noFollowingIndicatorTitle = "???????????????";

  static const String noRecommendationIndicatorTitle = "??????????????????????????????";

  static const String noRecommendationIndicatorSubtitle = "?????????????????????????????????????????????";

  static const String noStarIndicatorTitle = "?????????????????????";

  static const String noStarIndicatorSubtitle = "???????????????????????????????????????";

  static const String noMyPostIndicatorTitle = "???????????????";

  static const String noApprovalIndicatorTitle = "?????????????????????";
  static const String noStarredIndicatorTitle = "????????????????????????";
  static const String noReplyIndicatorTitle = "?????????????????????";
  static const String noFollowNotificationTitle = "??????????????????";

  static const String commentDeletedPrompt = "[?????????????????????]";
  static const String postFrozenPrompt = "?????????";
}

enum FollowStatus {
  none,
  followedByCurrentUser,
  followingCurrentUser,
  both,
}
enum Gender {
  male,
  female,
  secret,
}

enum ApprovalStatus {
  none,
  approve,
  disapprove,
}

enum SortPolicy {
  earliest,
  latest,
  hottest,
}

enum UserActionType {
  approval,
  follow,
  reply,
  star,
}

enum StatisticPeriodType { Day, Week, Month, All }

enum MessageType { Text, Image, TemporaryImage }

enum ChatterType {
  Me,
  Other,
}

enum MessageBoxType {
  Info,
  Error,
  Success,
}

enum CommentType {
  Post,
  Reply,
}

enum Setting {
  signOut,
}

enum PostTag { Life, Study, Art, Mood, Career }

enum MessageStatus { Normal, Sending, Failed }

enum UserType { Admin, User, Unauthorized, Banned, Silenced }

Map<String, UserType> userTypeMap = {
  "ADMIN": UserType.Admin,
  "USER": UserType.User,
  "UNAUTHORIZED": UserType.Unauthorized,
  "BANNED": UserType.Banned,
  "SILENCED": UserType.Silenced
};

Map<UserType, String> userTypeString = {
  UserType.Admin: "ADMIN",
  UserType.User: "USER",
  UserType.Unauthorized: "UNAUTHORIZED",
  UserType.Banned: "BANNED",
  UserType.Silenced: "SILENCED"
};

Map<String, FollowStatus> followStatusMap = {
  "NONE": FollowStatus.none,
  "FOLLOWED_BY_ME": FollowStatus.followedByCurrentUser,
  "FOLLOWING_ME": FollowStatus.followingCurrentUser,
  "BOTH": FollowStatus.both,
};

Map<ApprovalStatus, String> statusString = {
  ApprovalStatus.approve: "APPROVAL",
  ApprovalStatus.disapprove: "DISAPPROVAL",
  ApprovalStatus.none: "NONE"
};

Map<String, Gender> genderMap = {
  "MALE": Gender.male,
  "FEMALE": Gender.female,
  "SECRET": Gender.secret
};

Map<Gender, String> genderEnum2StringMap = {
  Gender.male: "???",
  Gender.female: "???",
  Gender.secret: "??????"
};
