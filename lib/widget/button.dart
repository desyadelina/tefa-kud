// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color outlineColor;
  final String text;
  final Color textColor;
  final Widget? icon;

  const button({
    super.key,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF43964F),
    required this.text,
    this.textColor = Colors.white,
    this.outlineColor = const Color(0xFF43964F),
    this.icon, SizedBox? child,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12),
              ],
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ],
          )),
    );
  }
}
