import 'package:comment_overflow/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Disable landscape mode.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(CommentOverflow());
}

class CommentOverflow extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '有可奉告',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blueAccent,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: Colors.blueAccent,
        )),
        buttonColor: Colors.blue.withOpacity(0.12),
        disabledColor: Colors.grey.withOpacity(0.5),
        secondaryHeaderColor: Colors.grey,
      ),
      initialRoute: RouteGenerator.homeRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
