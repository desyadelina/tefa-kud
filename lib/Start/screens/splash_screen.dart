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
  bool _isShowLabel = false;

  static const Duration showDuration = Duration(milliseconds: 600);
  static const Duration moveDuration = Duration(milliseconds: 2200);
  static const Duration navigateDelay = Duration(milliseconds: 1250);

  @override
  void initState() {
    super.initState();
    Future.delayed(showDuration, () {
      setState(() {
        _isShow = true;
        _isShowLabel = true;
      });
    });
    Future.delayed(moveDuration, () {
      setState(() {
        _isMoved = true;
        _isShowLabel = false;
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutExpo,
              opacity: _isShow ? 1 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                opacity: _isShowLabel ? 1 : 0,
                child: const Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Text(
                    "Koperasi Unit Desa",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 1250),
            curve: Curves.easeOutExpo,
            alignment:
                _isMoved ? const Alignment(-0.988, -0.917) : Alignment.center,
            child: AnimatedOpacity(
              opacity: _isShow ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedScale(
                scale: _isMoved ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  'assets/logo/koperasi-indonesia-seeklogo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
