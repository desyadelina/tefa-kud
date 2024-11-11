import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class IsiSaldoPage extends StatefulWidget {
  const IsiSaldoPage({super.key});

  @override
  State<IsiSaldoPage> createState() => _IsiSaldoPageState();
}

class _IsiSaldoPageState extends State<IsiSaldoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: GFButton(
            onPressed: () {},
            text: "primary",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
