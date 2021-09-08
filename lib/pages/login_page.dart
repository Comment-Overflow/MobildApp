import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
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

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) async {
    try {
      final response = await AuthService.login(data.name, data.password);
      Map<String, dynamic> loginDTOMap = response.data;
      final LoginDTO loginDTO = LoginDTO.fromJson(loginDTOMap);
      await StorageUtil().configOnLogin(loginDTO);
      await ChatService.initChat();
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

  _sendEmail(email, failureCallback) async {
    try {
      final Response response = await AuthService.sendEmailConfirmation(email);
      StorageUtil()
          .storage
          .write(key: Constants.emailToken, value: response.data);

      MessageBox.showToast(
          msg: "验证邮件已发送!", messageBoxType: MessageBoxType.Success);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        MessageBox.showToast(
            msg: "网络连接异常，请重试!", messageBoxType: MessageBoxType.Success);
      } else {
        MessageBox.showToast(
            msg: "未能成功发送邮件，请重试!", messageBoxType: MessageBoxType.Success);
      }
      failureCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).accentColor;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FlutterLogin(
        backgroundImage: AssetImage("assets/images/login_background.jpg"),
        loginAfterSignUp: false,
        logo: "assets/images/logo.png",
        messages: buildMessages(),
        hideForgotPasswordButton: true,
        onLogin: _login,
        onSignup: _signUp,
        onSubmitAnimationCompleted: () {
          Navigator.pushAndRemoveUntil(
              context,
              RouteGenerator.generateRoute(
                  RouteSettings(name: RouteGenerator.homeRoute)),
              (_) => false);
          // Navigator.of(context).pushReplacementNamed(RouteGenerator.homeRoute);
        },
        theme: LoginTheme(
            // Gradient background color.
            pageColorLight: Color.fromRGBO(1, 180, 59, 1.0),
            pageColorDark: Color.fromRGBO(29, 149, 63, 1),
            primaryColor: accentColor,
            titleStyle: TextStyle(
              color: Colors.white,
            ),
            cardTheme: CardTheme(
              elevation: 3,
            ),
            buttonTheme: LoginButtonTheme(
                elevation: 2,
                backgroundColor: Color.fromRGBO(38, 156, 70, 1.0)),
            accentColor: accentColor,
            authButtonPadding: EdgeInsets.only(top: 15.0, bottom: 5.0)),
        onRecoverPassword: _recoverPassword,
        emailRetryInterval: 30,
        onSend: _sendEmail,
      ),
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
        confirmPasswordError: '密码不匹配!',
      );
}
