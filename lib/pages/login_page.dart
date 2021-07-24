import 'package:after_layout/after_layout.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/socket_util.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      await StorageUtil().storage.delete(key: Constants.emailToken);
      return '';
    } on DioError catch (e) {
      if (e.response?.data == null) {
        return '网络连接异常!';
      }
      return e.response?.data as String;
    }
  }

  Future<String> _signUp(LoginData data) async {
    String? emailToken =
        await StorageUtil().storage.read(key: Constants.emailToken);
    try {
      await AuthService.register(
          data.name, data.password, data.emailConfirmation, emailToken);
      return '';
    } on DioError catch (e) {
      if (e.response?.data == null) {
        return '网络连接异常!';
      }
      return e.response?.data as String;
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  _sendEmail(email) async {
    try {
      final Response response = await AuthService.sendEmailConfirmation(email);
      StorageUtil()
          .storage
          .write(key: Constants.emailToken, value: response.data);
    } on DioError {}

    MessageBox.showToast(
        msg: "验证邮件已发送!", messageBoxType: MessageBoxType.Success);
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
      emailRetryInterval: 30,
      onSend: _sendEmail,
    );
  }

  buildMessages() => LoginMessages(
        userHint: '邮箱',
        passwordHint: '密码',
        confirmPasswordHint: '确认密码',
        loginButton: '登录',
        signupButton: '注册',
        flushbarTitleError: '出错啦',
        flushbarTitleSuccess: '成功',
        signUpSuccess: '注册成功!',
      );
}
