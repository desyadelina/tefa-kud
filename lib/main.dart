import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isMoved = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isMoved = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        alignment: _isMoved ? Alignment(-1.0, -1.0) : Alignment.center,
        child: AnimatedScale(
          scale: _isMoved ? 0.5 : 1.0,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: Image.asset('assets/logo.png', width: 100, height: 100),
        ),
      ),
    );
  }
}
