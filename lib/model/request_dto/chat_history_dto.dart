import 'package:dio/dio.dart';

class ChatHistoryDTO{
  final int _userId;
  final int _chatterId;
  final int _pageNumber;
  final int _pageSize;

  ChatHistoryDTO(
      this._userId, this._chatterId, this._pageNumber, this._pageSize);

  Future<FormData> formData() async => FormData.fromMap({
    'userId': _userId,
    'chatterId': _chatterId,
    'pageNum': _pageNumber,
    'pageSize': _pageSize
  });
}