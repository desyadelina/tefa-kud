
import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/button.dart';

class GuideLayout extends StatelessWidget {
  final PageController controller;
  final String title;
  final String subtitle;
  final String imagePath;
  final double transformScale;

  const GuideLayout({
    super.key,
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.transformScale = 1.0,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Transform.scale(
                scale: transformScale,
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRect(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
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
                        fontSize: 26,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 2, // Limit text to 2 lines
                      overflow:
                          TextOverflow.ellipsis, 
                      textAlign:
                          TextAlign.left,
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
              Align(
                alignment: Alignment.center,
                child: ClipRect(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.66,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
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
                        fontSize: 32,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      subtitle,
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
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
            child: button(
              onPressed: onNextPressed,
              backgroundColor: const Color(0xFF43964F),
              text: "Mulai",
            ),
          ),
        ),
      ],
    );
  }
}
