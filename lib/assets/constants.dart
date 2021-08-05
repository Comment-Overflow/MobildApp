class Constants {
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
  static const defaultAvatarInCommentSize = 24.0;

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
  static const defaultPersonalPageHeaderTitleSize = 22.5;

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

  static const messageBoxFontSize = 16.0;

  /// Default nine-pattern spacing.
  static const defaultNinePatternSpacing = 6.0;

  static const defaultHighlightTime = 2000;

  /// Default page size when getting chat history from backend.
  static const HTTPChatHistoryPage = 15;

  static const maxSearchHistory = 20;

  static const postCommentTimeout = 30;

  // Categories of posts
  static const List<String> postCategories = [
    '校园生活',
    '学在交大',
    '文化艺术',
    '心情驿站',
    '职业发展'
  ];

  // Texts of sorter in personal page
  static const List<String> sorterTexts = [
    '按时间排序',
    '按时间排序',
    '按热度排序',
  ];

  static const List<String> personalPageTabs = ["我的帖子", "我的回复", "我的收藏"];

  static const List<String> statisticPageTabs = ["今天", "本周", "本月", "所有"];

  static const List<String> statistics = ["发帖数", "评论数", "新注册用户", "活跃用户", "点赞数", "浏览量"];

  static const String emailToken = 'emailToken';

  static const String token = 'token';

  static const String userId = 'userId';

  static const String userName = 'userName';

  static const String avatarUrl = 'avatarUrl';

  static const String searchHistory = 'searchHistory';

  static const String userType = 'userType';

  static const String imageLastMessage = '[图片]';

  static const String imageLoadingError = '图片加载失败';

  static const String imageReloadPrompt = '点击重新加载';

  static const String networkError = '网络错误';

  static const String searchCommentEmptyIndicatorTitle = '找不到话题';

  static const String searchCommentEmptyIndicatorSubtitle = '试试换个姿势搜索';

  static const String searchUserEmptyIndicatorTitle = '找不到用户';

  static const String searchUserEmptyIndicatorSubtitle = '也许只是擦肩而过';

  static const String commentEmptyIndicatorTitle = "还没有发言";

  static const String followingCommentEmptyIndicatorSubtitle = "人都是需要休息的";

  static const String browsePostIndicatorTitle = '还没有话题';

  static const String browsePostEmptyIndicatorSubtitle = '做第一个打破沉默的人吧';
}

enum FollowStatus {
  none,
  followedByMe,
  followingMe,
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

enum StatisticPeriodType {
  Day, Week, Month, All
}

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
  "FOLLOWED_BY_ME": FollowStatus.followedByMe,
  "FOLLOWING_ME": FollowStatus.followingMe,
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
  Gender.male: "男",
  Gender.female: "女",
  Gender.secret: "保密"
};
