class Quote {
  // Title can be user name, or post title.
  final String _title;
  final String _content;
  final int _floor;

  String get title => _title;
  String get content => _content;
  int get floor => _floor;

  Quote(this._title, this._content, this._floor);

  factory Quote.fromJson(dynamic json) => Quote(
      json['title'] as String,
      json['content'] as String,
      json['floor'] as int
  );

}
