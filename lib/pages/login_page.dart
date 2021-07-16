import 'package:comment_overflow/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const users = const {
  '123@123.com': '123456',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return '用户不存在!';
      }
      if (users[data.name] != data.password) {
        return '密码不匹配!';
      }
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '有可奉告',
      messages: buildMessages(),
      hideForgotPasswordButton: true,
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(RouteGenerator.homeRoute);
      },
      theme: LoginTheme(
        primaryColor: Theme.of(context).accentColor,
        titleStyle: TextStyle(),
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