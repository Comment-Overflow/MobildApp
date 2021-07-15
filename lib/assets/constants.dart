class Constants {
  /// Default page size of pageable list.
  static const defaultPageSize = 8;
  /// Default padding of any card component.
  static const defaultCardPadding = 16.0;
  /// Default size of Avatar in commentCard.
  static const defaultAvatarInCommentSize = 24.0;
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