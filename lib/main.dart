import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/screens/UserDrawer/profile/utils/user_preferences.dart';
import 'package:redditech/screens/UserDrawer/user_drawer.dart';
import 'package:redditech/screens/bottomNavBars/bottom_nav_bar.dart';
import 'package:redditech/screens/login/login.dart';

import 'screens/UserDrawer/profile/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Sets the tooltip to [Key], which should have been word wrapped using
  /// the current font.
  const MyApp({Key? key}) : super(key: key);

  /// This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RedditProvider(),
        )
      ],
      child: ThemeProvider(
          initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
          child: Builder(
            builder: (context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeProvider.of(context),
                title: 'ReddiTech',
                routes: {
                  'login': (context) => const Login(),
                  'main': (context) => const BottomNavBarPage(),
                },
                initialRoute: 'login',
                onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
                    builder: (context) => const UnknownPage())),
          )),
    );
  }
}
class UnknownPage extends StatelessWidget {
  /// Sets the tooltip to [Key], which should have been word wrapped using
  /// the current font. This class prevent form error that we can find
  /// with a UnknownPage
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("404"),
        leading: const Icon(Icons.menu),
        actions: const [
          Icon(Icons.settings),
        ],
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back")),
          ],
        ),
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  /// Sets the tooltip to [Key], creating the front page during the connexion.
  const MainHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // await AuthService.login();
                  //       var s = await reddit.user.me();
                  // print("my reddit username: "+ (s!.fullname ?? "Error: string is empty"));
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          )),
      drawer: const UserDrawer(),
      body: const Center(),
    );
  }
}
