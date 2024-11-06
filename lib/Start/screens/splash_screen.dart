import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/guide_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isMoved = false;
  bool _isShow = false;

  static const Duration showDuration = Duration(milliseconds: 500);
  static const Duration moveDuration = Duration(milliseconds: 2000);
  static const Duration navigateDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Future.delayed(showDuration, () {
      setState(() {
        _isShow = true;
      });
    });
    Future.delayed(moveDuration, () {
      setState(() {
        _isMoved = true;
        Future.delayed(navigateDelay, () {
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GuideMain()),
            );
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        alignment:
            _isMoved ? const Alignment(-0.957, -0.905) : Alignment.center,
        child: AnimatedOpacity(
          opacity: _isShow ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedScale(
            scale: _isMoved ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Image.asset(
              'assets/logo/koperasi-indonesia-seeklogo.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
