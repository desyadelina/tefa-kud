import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/button.dart';

class StartGuideLayout extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onNextPressed;

  const StartGuideLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onNextPressed,
  });

  @override
  State<StartGuideLayout> createState() => _StartGuideLayoutState();
}

class _StartGuideLayoutState extends State<StartGuideLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  double _bottomPosition = -100;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _bottomPosition =
              MediaQuery.of(context).size.height * 0.1; // Target posisi
        });
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Align(
                      alignment: Alignment.center,
                      child: ClipRect(
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.66,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          bottom: _bottomPosition, // Posisi animasi bottom
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: button(
              onPressed: widget.onNextPressed,
              backgroundColor: const Color(0xFF43964F),
              text: "Mulai",
            ),
          ),
        ),
      ],
    );
  }
}
