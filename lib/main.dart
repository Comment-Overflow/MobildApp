import 'package:comment_overflow/pages/post_page.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
      title: '有可奉告',
      theme: ThemeData(
        primarySwatch: MaterialColor(Colors.blueAccent.value, const {
          50: Colors.blueAccent,
          100: Colors.blueAccent,
          200: Colors.blueAccent,
          300: Colors.blueAccent,
          400: Colors.blueAccent,
          500: Colors.blueAccent,
          600: Colors.blueAccent,
          700: Colors.blueAccent,
          800: Colors.blueAccent,
          900: Colors.blueAccent,
        }),
        primaryColor: Colors.white,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent
        ),
        accentColor: Colors.blueAccent,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            // Remove text button horizontal padding.
            minimumSize: MaterialStateProperty.all(Size(1, 1)),
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 6.0)),
          ),
        ),
        buttonColor: Colors.blue.withOpacity(0.12),
        disabledColor: Colors.grey.withOpacity(0.5),
        secondaryHeaderColor: Colors.grey,
      ),
      initialRoute: RouteGenerator.introRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: GlobalUtils.navKey,
    );
  }
}
