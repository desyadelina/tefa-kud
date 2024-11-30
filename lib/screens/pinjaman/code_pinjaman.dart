// ignore_for_file: use_super_parameters, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';
import 'package:intl/intl.dart';

class CodePinjaman extends StatefulWidget {
  final String title;
  final String nominal;
  final String date;
  final String noRekPengguna;
  final String tenor;
  const CodePinjaman({
    Key? key,
    required this.title,
    required this.nominal,
    required this.date,
    required this.noRekPengguna,
    required this.tenor,
  }) : super(key: key);

  @override
  State<CodePinjaman> createState() => _CodePinjamanState();
}

class _CodePinjamanState extends State<CodePinjaman> {
  String get kodePinjaman => 'PI-${DateTime.now().millisecondsSinceEpoch}';

  String get nominal => widget.nominal;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Color.fromARGB(255, 67, 150, 79),
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Nominal Pinjaman',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 67, 150, 79),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Rp',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      currencyFormat.format(double.parse(widget.nominal)),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Second Container: Kode Pinjaman
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Kode Pinjaman',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                 kodePinjaman,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 67, 150, 79),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    // Copy kodePinjaman to clipboard
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        25, 67, 150, 79), // Hijau dengan opacity 10%
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  icon: const Icon(
                    Icons.copy,
                    color: Color.fromARGB(255, 67, 150, 79),
                  ),
                  label: const Text(
                    'Salin Kode',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 150, 79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Third Container: Informasi
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Tunjukkan kode ini ke\nKoperasi Unit Daerah segera',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Jam Operasional\nSenin-Kamis: 06.00-22.00 WITA\nJumat-Minggu: 06.00-11.00 WITA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
