import 'package:comment_overflow/pages/post_page.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

void main() async {
  // Disable landscape mode.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RecentChatsProvider()),
    ChangeNotifierProvider(create: (_) => MaxPageCounter()),
  ], child: CommentOverflow()));
}

class CommentOverflow extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: LinearGradient(
        colors: [
          Color(0xFFEBEBEB),
          Colors.white,
          Color(0xFFEBEBEB),
        ],
        stops: [
          0.4,
          0.5,
          0.6,
        ],
        begin: Alignment(-2.4, -3),
        end: Alignment(2.4, 3),
        tileMode: TileMode.clamp,
      ),
      child: MaterialApp(
        title: '有可奉告',
        theme: ThemeData(
          primarySwatch: MaterialColor(Colors.blueAccent.value, const {
            50: Colors.orangeAccent,
            100: Colors.orangeAccent,
            200: Colors.orangeAccent,
            300: Colors.orangeAccent,
            400: Colors.orangeAccent,
            500: Colors.orangeAccent,
            600: Colors.orangeAccent,
            700: Colors.orangeAccent,
            800: Colors.orangeAccent,
            900: Colors.orangeAccent,
          }),
          primaryColor: Colors.white,
          accentColor: Colors.orangeAccent,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              // Remove text button horizontal padding.
              minimumSize: MaterialStateProperty.all(Size(1, 1)),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 6.0)),
            ),
          ),
          buttonColor: Colors.orange.withOpacity(0.12),
          disabledColor: Colors.grey.withOpacity(0.5),
          secondaryHeaderColor: Colors.grey,
        ),
        initialRoute: RouteGenerator.introRoute,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: GlobalUtils.navKey,
      ),
    );
  }
}
