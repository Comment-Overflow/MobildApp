import 'package:after_layout/after_layout.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/socket_client.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AfterLayoutMixin<IntroPage> {
  Future<bool> _autoLogin(context) async {
    String? token = await StorageUtil().storage.read(key: Constants.token);
    if (token != null) {
      try {
        final response = await AuthService.autoLogin();
        // Rejected by interceptor.
        if (response.data.runtimeType == String) {
          print(response.data);
          return false;
        }
        final LoginDTO loginDTO = LoginDTO.fromJson(response.data);
        await StorageUtil().configOnLogin(loginDTO);
        await ChatService.initChat();
        return true;
      } on DioError {
        // Stop auto login.
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Change intro content.
    return Scaffold(body: Center(child: Text('放个图标！')));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // Delay for one second after auto login is successful.
    if (await _autoLogin(context) == true) {
      Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteGenerator.homeRoute));
    } else {
      Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteGenerator.loginRoute));
    }
  }
}
