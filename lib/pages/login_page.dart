import 'package:after_layout/after_layout.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) async {
    try {
      final response = await AuthService.login(data.name, data.password);
      Map<String, dynamic> loginDTOMap = response.data;
      final LoginDTO loginDTO = LoginDTO.fromJson(loginDTOMap);
      await StorageUtil()
          .storage
          .write(key: Constants.token, value: loginDTO.token);
      await StorageUtil()
          .storage
          .write(key: Constants.userId, value: loginDTO.userId.toString());
      return '';
    } on DioError catch (e) {
      if (e.response?.data == null) {
        return '网络连接异常!';
      }
      return e.response?.data as String;
    }
  }

  Future<String> _signUp(LoginData data) async {
    try {
      await AuthService.register(data.name, data.password);
      return '';
    } on DioError catch (e) {
      if (e.response?.data == null) {
        return '网络连接异常!';
      }
      return e.response?.data as String;
    }
  }

  // FIXME: Move to another page.
  Future<bool> _autoLogin(context) async {
    String? token = await StorageUtil().storage.read(key: Constants.token);
    if (token != null) {
      try {
        final response = await AuthService.autoLogin();
        final LoginDTO loginDTO = LoginDTO.fromJson(response.data);
        await StorageUtil()
            .storage
            .write(key: Constants.token, value: loginDTO.token);
        await StorageUtil()
            .storage
            .write(key: Constants.userId, value: loginDTO.userId.toString());
        return true;
      } on DioError {
        // Stop auto login.
        return false;
      }
    }
    return false;
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
      loginAfterSignUp: false,
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
          primaryColor: Colors.blueAccent,
          titleStyle: TextStyle(
            color: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 3,
          ),
          buttonTheme: LoginButtonTheme(
              elevation: 2, backgroundColor: Color(0xFF3F84DE)),
          accentColor: Colors.blueAccent,
          authButtonPadding: EdgeInsets.only(top: 15.0, bottom: 5.0)),
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

  @override
  void afterFirstLayout(BuildContext context) async {
    if (await _autoLogin(context) == true) {
      Navigator.of(context).pushReplacementNamed(RouteGenerator.homeRoute);
    }
  }
}
