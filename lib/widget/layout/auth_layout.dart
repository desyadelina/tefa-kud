// ignore: file_names
import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
  final Widget content;
  final String title;
  const AuthLayout({
    required this.content,
    this.title = "Auth Screen",
    super.key});

  @override
  State<AuthLayout> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.content,
    );
  }
}
