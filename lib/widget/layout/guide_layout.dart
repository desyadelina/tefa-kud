import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/guide_screen.dart';
import 'package:tefa_kud/widget/button.dart';

class GuideLayout extends StatelessWidget {
  final PageController controller;
  final String title;
  final String subtitle;
  final String imagePath;

  const GuideLayout({
    super.key,
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

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
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRect(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 2, // Limit text to 2 lines
                      overflow:
                          TextOverflow.ellipsis, // Add "..." if text overflows
                      textAlign:
                          TextAlign.left, // Optional: Center-align if needed
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StartGuideLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: 0.58,
                      child: Image.asset(imagePath),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    button(
                      onPressed: onNextPressed,
                      backgroundColor: const Color(0xFF43964F),
                      text: "Mulai",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
