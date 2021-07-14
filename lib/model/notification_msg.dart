enum NotificationType {approvePost, approveComment, collect, attention, reply}

class NotificationMsg {

  final _userName;
  final String? _title;
  final String? _comment;
  final NotificationType _type;

  get userName => _userName;

  get title => _title;

  get comment => _comment;

  get type => _type;

  NotificationMsg(this._userName, this._title, this._comment, this._type);
}