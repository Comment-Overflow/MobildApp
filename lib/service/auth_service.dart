import 'dart:async';

import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Future<Response> login(email, password) async {
    return await HttpUtil()
        .dio
        .post('/sessions', data: {'email': email, 'password': password});
  }

  static Future<Response> register(email, password) async {
    return await HttpUtil()
        .dio
        .post('/users', data: {'email': email, 'password': password});
  }
}
