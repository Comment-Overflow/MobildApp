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
  static const defaultButtonPaddinqg = 5.0;
  /// Default size of Avatar in commentCard.
  static const defaultAvatarInCommentSize = 24.0;
  static const defaultAppBarElevation = 0.5;
  /// Search bar height.
  static const searchBarHeight = 32.0;
  /// Max image number of a comment.
  static const maxImageNumber = 9;
}

enum FollowStatus {
  none, followedByMe, followingMe, both,
}
enum Sex {
  male, female,
}

enum ApprovalStatus {
  none, approve, disapprove,
}

enum SortPolicy {
  earliest, latest, hottest,
}