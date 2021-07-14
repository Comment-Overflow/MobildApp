class CombinedUser {

  final String _username;
  final String _description;
  final int _postCount;
  final int _followerCount;
  final bool _isFollowing;

  get username => _username;

  get description => _description;

  get isFollowing => _isFollowing;

  get followerCount => _followerCount;

  get postCount => _postCount;

  CombinedUser(this._username, this._description, this._postCount,
      this._followerCount, this._isFollowing);

}