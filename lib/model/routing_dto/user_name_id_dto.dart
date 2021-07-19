/// Contains user name and id only.
class UserNameIdDto {
  int _id;
  String _userName;

  int get id => _id;
  String get userName => _userName;

  UserNameIdDto(this._id, this._userName);
}
