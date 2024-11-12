import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';

class ReceiptIsiSaldo extends StatefulWidget {
  final String nominal;
  final String date;

  const ReceiptIsiSaldo({
    Key? key,
    required this.nominal,
    required this.date,
  }) : super(key: key);

  @override
  State<ReceiptIsiSaldo> createState() => _ReceiptIsiSaldoState();
}

class _ReceiptIsiSaldoState extends State<ReceiptIsiSaldo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 67, 150, 79),
          title: const Text(
            'Bukti Isi Saldo',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/Transfer.png',
                      color: Colors.green,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Nominal Isi Saldo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "909090",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
