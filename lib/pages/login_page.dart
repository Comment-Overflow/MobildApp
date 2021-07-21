import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) async {
    try {
      final response = await AuthService.login(data.name, data.password);
      final int userId = response.extra['userId'];
      final String token = response.extra['token'];
      await StorageUtil().storage.write(key: 'userId', value: userId as String);
      await StorageUtil().storage.write(key: 'token', value: token);
      return '';
    } on DioError catch (e) {
      return e.response?.data as String;
    }
  }

  Future<String> _signUp(LoginData data) async {
    try {
      await AuthService.register(data.name, data.password);
      return '';
    } on DioError catch (e) {
      return e.response?.data as String;
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '有可奉告',
      messages: buildMessages(),
      hideForgotPasswordButton: true,
      onLogin: _login,
      onSignup: _signUp,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(RouteGenerator.homeRoute);
      },
      theme: LoginTheme(
        // Gradient background color.
        pageColorLight: Color(0xFF77ACF1),
        pageColorDark: Color(0xFF0500B6),
        primaryColor: Color(0xFF3F84DE),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 3,
        ),

        buttonTheme:
            LoginButtonTheme(elevation: 2, backgroundColor: Color(0xFF3F84DE)),
        accentColor: Color(0xff4557cd),
        authButtonPadding: EdgeInsets.only(top: 15.0, bottom: 5.0),
      ),
      onRecoverPassword: _recoverPassword,
    );
  }

  buildMessages() => LoginMessages(
        userHint: '邮箱',
        passwordHint: '密码',
        confirmPasswordHint: '确认密码',
        loginButton: '登录',
        signupButton: '注册',
      );
}
