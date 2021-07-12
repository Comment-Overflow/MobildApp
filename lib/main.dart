import 'package:flutter/material.dart';
import 'package:zhihu_demo/utils/route_generator.dart';

void main() {
  runApp(ZhiHu());
}

class ZhiHu extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '畅所欲言',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blueAccent,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

