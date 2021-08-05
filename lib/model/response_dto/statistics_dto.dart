class StatisticsDTO {
  final int _postCountLastDay;
  final int _commentCountLastDay;
  final int _userCountLastDay;
  final int _activeUserCountLastDay;
  final int _approvalCountLastDay;
  final int _viewCountLastDay;

  final int _postCountLastWeek;
  final int _commentCountLastWeek;
  final int _userCountLastWeek;
  final int _activeUserCountLastWeek;
  final int _approvalCountLastWeek;
  final int _viewCountLastWeek;

  final int _postCountLastMonth;
  final int _commentCountLastMonth;
  final int _userCountLastMonth;
  final int _activeUserCountLastMonth;
  final int _approvalCountLastMonth;
  final int _viewCountLastMonth;

  final int _postCountOverall;
  final int _commentCountOverall;
  final int _userCountOverall;
  final int _activeUserCountOverall;
  final int _approvalCountOverall;
  final int _viewCountOverall;

  int get postCountLastDay => _postCountLastDay;

  int get commentCountLastDay => _commentCountLastDay;

  int get approvalCountOverall => _approvalCountOverall;

  int get activeUserCountOverall => _activeUserCountOverall;

  int get viewCountLastDay => _viewCountLastDay;


  int get viewCountLastWeek => _viewCountLastWeek;

  int get userCountOverall => _userCountOverall;

  int get commentCountOverall => _commentCountOverall;

  int get postCountOverall => _postCountOverall;

  int get approvalCountLastMonth => _approvalCountLastMonth;

  int get activeUserCountLastMonth => _activeUserCountLastMonth;

  int get userCountLastMonth => _userCountLastMonth;

  int get commentCountLastMonth => _commentCountLastMonth;

  int get postCountLastMonth => _postCountLastMonth;

  int get approvalCountLastWeek => _approvalCountLastWeek;

  int get activeUserCountLastWeek => _activeUserCountLastWeek;

  int get userCountLastWeek => _userCountLastWeek;

  int get commentCountLastWeek => _commentCountLastWeek;

  int get postCountLastWeek => _postCountLastWeek;

  int get approvalCountLastDay => _approvalCountLastDay;

  int get activeUserCountLastDay => _activeUserCountLastDay;

  int get userCountLastDay => _userCountLastDay;

  int get viewCountLastMonth => _viewCountLastMonth;

  int get viewCountOverall => _viewCountOverall;

  int getCountByIndex(int index) {
    switch (index) {
      case 0: return _postCountLastDay;
      case 1: return _commentCountLastDay;
      case 2: return _userCountLastDay;
      case 3: return _activeUserCountLastDay;
      case 4: return _approvalCountLastDay;
      case 5: return _viewCountLastDay;

      case 6: return _postCountLastWeek;
      case 7: return _commentCountLastWeek;
      case 8: return _userCountLastWeek;
      case 9: return _activeUserCountLastWeek;
      case 10: return _approvalCountLastWeek;
      case 11: return _viewCountLastWeek;

      case 12: return _postCountLastMonth;
      case 13: return _commentCountLastMonth;
      case 14: return _userCountLastMonth;
      case 15: return _activeUserCountLastMonth;
      case 16: return _approvalCountLastMonth;
      case 17: return _viewCountLastMonth;

      case 18: return _postCountOverall;
      case 19: return _commentCountOverall;
      case 20: return _userCountOverall;
      case 21: return _activeUserCountOverall;
      case 22: return _approvalCountOverall;
      case 23: return _viewCountOverall;

      default: return 0;
    }
  }

  StatisticsDTO.fromList(List<dynamic> list)
      : _postCountLastDay = list[0] as int,
        _commentCountLastDay = list[1] as int,
        _userCountLastDay = list[2] as int,
        _activeUserCountLastDay = list[3] as int,
        _approvalCountLastDay = list[4] as int,
        _viewCountLastDay = list[5] as int,

        _postCountLastWeek = list[6] as int,
        _commentCountLastWeek = list[7] as int,
        _userCountLastWeek = list[8] as int,
        _activeUserCountLastWeek = list[9] as int,
        _approvalCountLastWeek = list[10] as int,
        _viewCountLastWeek = list[11] as int,

        _postCountLastMonth = list[12] as int,
        _commentCountLastMonth = list[13] as int,
        _userCountLastMonth = list[14] as int,
        _activeUserCountLastMonth = list[15] as int,
        _approvalCountLastMonth = list[16] as int,
        _viewCountLastMonth = list[17] as int,

        _postCountOverall = list[18] as int,
        _commentCountOverall = list[19] as int,
        _userCountOverall = list[20] as int,
        _activeUserCountOverall = list[21] as int,
        _approvalCountOverall = list[22] as int,
        _viewCountOverall = list[23] as int;

}
