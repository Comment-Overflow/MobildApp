import 'dart:async';

import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';

class AuthService {
  static final Dio _dio = HttpUtil().dio;

  static Future<Response> login(email, password) async {
    return await _dio
        .post('/sessions', data: {'email': email, 'password': password});
  }

  static Future<Response> register(
      email, password, userCode, emailToken) async {
    return await _dio.post('/users', data: {
      'email': email,
      'password': password,
      'userCode': userCode,
      'emailToken': emailToken
    });
  }

  static Future<Response> autoLogin() async {
    return await _dio.get('/sessions');
  }

  static Future<Response> sendEmailConfirmation(email) async {
    return await _dio.post('/emails', data: email);
  }
}
