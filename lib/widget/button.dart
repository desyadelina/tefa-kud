import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/guide_screen.dart';

class button extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color outlineColor;
  final String text;
  final Color textColor;

  const button({
    super.key,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF43964F),
    required this.text,
    this.textColor = Colors.white,
    this.outlineColor = const Color(0xFF43964F),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: outlineColor, width: 1.4),
              )),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          )),
    );
  }
}
