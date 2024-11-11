import 'package:flutter/material.dart';

import 'package:tefa_kud/Settings/screens/profile_edit_screen.dart';
import 'package:tefa_kud/Settings/screens/profile_screen.dart';
import 'package:tefa_kud/Start/screens/splash_screen.dart';
import 'package:tefa_kud/widget/layout/detailed_layout.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';

class NavigatorManager {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateWithoutAnimation(String routeName) {
    return navigatorKey.currentState?.push(PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) {
        return getRouteWidget(routeName); // Fungsi untuk mengambil widget berdasarkan routeName
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    )) ?? Future.value();
  }

  // Fungsi untuk mengambil widget sesuai route
  static Widget getRouteWidget(String routeName) {
    switch (routeName) {
      case '/profileEdit':
        return ProfileEditScreen();
      default:
        return MainLayout();
    }
  }
}
void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: NavigatorManager.navigatorKey,
      routes: {
        '/': (context) => const MainLayout(), 
        '/splashscreen': (context) => const SplashScreen(), 
        '/profile': (context) => const ProfilePage(),
        '/profileEdit': (context) => const DetailedPage(content: ProfileEditScreen(), background: Color(0xFFF2F2F2),),
      },
      theme: ThemeData(
        fontFamily: 'RedRose',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF43964F),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
