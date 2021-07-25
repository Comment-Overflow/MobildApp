import 'dart:convert';

import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileSettingService {
  static Future<Response> putProfile(String url, FormData formData) async {
    return await HttpUtil().dio.put(url, data: formData);
  }
  static void getProfile(String url, ValueSetter callback) async {
     Map<String, dynamic> json = (await HttpUtil().dio.get(url)).data;
     callback(json);
  }
}