import 'package:flutter/material.dart';

class DetailedPage extends StatefulWidget {
  final String titleBar;
  final Color backgroundBar;

  const DetailedPage(
      {required this.titleBar,
      this.backgroundBar = const Color(0xFF43964F),
      super.key});

  @override
  State<DetailedPage> createState() => _DetailedPagedState();
}

class _DetailedPagedState extends State<DetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF43964F),
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.titleBar,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RedRose',
            ),
          ),
        ),
        backgroundColor: widget.backgroundBar,
        toolbarHeight: 98,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                border: Border.all(style: BorderStyle.none),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // Radius untuk sudut kiri atas
                  topRight:
                      Radius.circular(20), // Radius untuk sudut kanan atas
                ),
                color: Colors.white,
              ),
              width: double.infinity,
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.802,
            ),
          ],
        ),
      ),
    );
  }
}
