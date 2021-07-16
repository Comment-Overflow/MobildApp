class Constants {
  /// Default page size of pageable list.
  static const defaultPageSize = 8;

  /// Default page size of notification page list.
  static const defaultNotificationPageSize = 10;

  /// Default padding of any card component.
  static const defaultCardPadding = 16.0;

  /// Default size height of a user card.
  static const defaultUserCardHeight = 100.0;

  /// Default padding of a button.
  static const defaultButtonPadding = 5.0;

  /// Default size of Avatar in commentCard.
  static const defaultAvatarInCommentSize = 24.0;

  /// Default size of buttons in notification page.
  static const defaultNotificationButtonSize = 38.0;

  /// Default size height of a chat card.
  static const defaultChatCardHeight = 80.0;

  /// Default size of chat avatar.
  static const defaultChatListAvatarSize = 65.0;

  static const defaultAppBarElevation = 0.5;

  /// Search bar height.
  static const searchBarHeight = 32.0;

  /// Maximum characters for post title.
  static const postTitleMaximumLength = 30;

  /// Default size of avatar in chat room.
  static const defaultChatRoomAvatarSize = 50.0;

  /// Default left padding of avatar in chat room.
  static const defaultChatRoomAvatarPadding = 5.0;

  /// Default vertical padding of chat message.
  static const defaultChatMessagePadding = 4.0;

  /// Default max chat bubble width.
  static const defaultMaxBubbleWidth = 200.0;

  /// Default chat room padding.
  static const defaultChatRoomPadding = 10.0;

  /// Max image number of a comment.
  static const maxImageNumber = 9;
}

enum FollowStatus {
  none,
  followedByMe,
  followingMe,
  both,
}
enum Sex {
  male,
  female,
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

enum NotificationType { approvePost, approveComment, collect, attention, reply }

enum MessageType { Text, Image }

enum ChatterType {
  Me,
  Other,
}
