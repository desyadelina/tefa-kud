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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 450), () {
      setState(() {
        _isShow = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _isMoved = true;
        Future.delayed(const Duration(milliseconds: 515), () {
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
        color: const Color(0xFF43964F),
        duration: const Duration(milliseconds: 490),
        curve: Curves.easeInExpo,
        alignment:
            _isMoved ? const Alignment(-0.955, -0.905) : Alignment.center,
        child: AnimatedScale(
          scale: _isMoved ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 490),
          child: Image.asset('assets/logo/koperasi-indonesia-seeklogo.png',
              width: 100, height: 100),
        ),
      ),
    );
  }
}
