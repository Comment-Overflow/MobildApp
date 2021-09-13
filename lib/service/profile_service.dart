import 'package:comment_overflow/utils/http_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileService {
  static Future<Response> putProfileSetting(String url, FormData formData) async {
    return HttpUtil().dio.put(url, data: formData);
  }
  static Future getProfile(String url, ValueSetter callback) async {
     Map<String, dynamic> json = (await HttpUtil().dio.get(url)).data;
     print(json);
     callback(json);
  }
}
