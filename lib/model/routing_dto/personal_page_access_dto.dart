class PersonalPageAccessDto {
  final int _userId;
  final bool _fromCard;

  int get userId => _userId;

  bool get fromCard => _fromCard;

  PersonalPageAccessDto(this._userId, this._fromCard);
}
