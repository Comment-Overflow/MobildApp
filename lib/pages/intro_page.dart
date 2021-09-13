import 'package:after_layout/after_layout.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:comment_overflow/service/auth_service.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/utils/route_generator.dart';
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
    with AfterLayoutMixin<IntroPage>, SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/login_background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Container(),
              ),
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              Expanded(flex: 20, child: Container()),
              Image.asset(
                "assets/images/developed_by.png",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              Expanded(
                flex: 5,
                child: Container(),
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // Delay for 1500 milliseconds after auto login is successful.
    if (await _autoLogin(context) == true) {
      Future.delayed(
          Duration(milliseconds: 1500),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteGenerator.fadingHomeRoute));
    } else {
      Future.delayed(
          Duration(milliseconds: 1500),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteGenerator.loginRoute));
    }
  }
}
