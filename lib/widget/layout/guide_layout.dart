
import 'package:flutter/material.dart';

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


