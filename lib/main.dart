import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/guide_screen.dart';
import 'package:tefa_kud/Start/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'RedRose'),
      home: SplashScreen(),
    );
  }
}
