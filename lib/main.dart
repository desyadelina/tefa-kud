import 'package:flutter/material.dart';
import 'package:tefa_kud/screens/intro/splash_screen.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/pinjaman/pinjaman.dart';
import 'package:tefa_kud/screens/profile/profile_edit_screen.dart';
import 'package:tefa_kud/screens/profile/profile_screen.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';

import 'package:tefa_kud/widget/layout/detailed_layout.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';

class NavigatorManager {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateWithoutAnimation(String routeName) {
    return navigatorKey.currentState?.push(PageRouteBuilder(
          settings: RouteSettings(name: routeName),
          pageBuilder: (context, animation, secondaryAnimation) {
            return getRouteWidget(
                routeName); // Fungsi untuk mengambil widget berdasarkan routeName
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        )) ??
        Future.value();
  }

  static Widget getRouteWidget(String routeName) {
    switch (routeName) {
      case '/profileEdit':
        return ProfileEditScreen();
      case '/transfer':
        return ListTransfer();
      case '/isiSaldo':
        return IsiSaldoPage();
      case '/tarikTunai':
        return TarikTunaiPage();
      case '/pinjaman':
        return PinjamanPage();
      default:
        return MainLayout(
          title: '',
        );
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
        '/': (context) => MainLayout(
              title: '',
            ),
        '/splashscreen': (context) => const SplashScreen(),
        '/profile': (context) => ProfilePage(),
        '/transfer': (context) => const ListTransfer(),
        '/isiSaldo': (context) => const IsiSaldoPage(),
        '/tarikTunai': (context) => const TarikTunaiPage(),
        '/pinjaman': (context) => const PinjamanPage(),
        '/profileEdit': (context) => const DetailedPage(
              content: ProfileEditScreen(),
              background: Color(0xFFF2F2F2),
            ),
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
