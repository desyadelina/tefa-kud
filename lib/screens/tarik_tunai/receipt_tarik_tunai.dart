import 'package:flutter/material.dart';

class ReceiptTarikTunai extends StatefulWidget {
  final String title;
  final String nominal;
  final String date;
  final String namaPengguna;
  final String noRekPengguna;
  const ReceiptTarikTunai({
    super.key,
    required this.title,
    required this.nominal,
    required this.date,
    required this.namaPengguna,
    required this.noRekPengguna,
  });

  @override
  State<ReceiptTarikTunai> createState() => _ReceiptTarikTunaiState();
}

class _ReceiptTarikTunaiState extends State<ReceiptTarikTunai> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}