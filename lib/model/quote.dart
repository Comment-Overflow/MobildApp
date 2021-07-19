class Quote {
  // Title can be user name, or post title.
  final String _title;
  final String _content;

  String get title => _title;

  String get content => _content;

  Quote(this._title, this._content);
}
