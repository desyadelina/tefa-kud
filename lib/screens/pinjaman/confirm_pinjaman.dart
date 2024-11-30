// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/pinjaman/input_pin_pinjaman.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class ConfirmPinjaman extends StatefulWidget {
  final String title;
  final String userSlug;
  final String noRekPengguna;
  final double nominalPinjaman;
  final String tenor;
  const ConfirmPinjaman(
      {super.key,
      required this.title,
      required this.userSlug,
      required this.noRekPengguna,
      required this.nominalPinjaman,
      required this.tenor});

  @override
  State<ConfirmPinjaman> createState() => _ConfirmPinjamanState();
}

class _ConfirmPinjamanState extends State<ConfirmPinjaman>
    with WidgetsBindingObserver {
  String? noRekPengguna;
  double saldoAkhir = 0.0;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    TransactionService transactionService = TransactionService();

    var currentUser = await transactionService.getCurrentUser();
    if (currentUser != null) {
      String slug = currentUser['slug'];

      var rekeningData = await transactionService.getRekeningPengguna(
          slug, widget.noRekPengguna);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          saldoAkhir = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble() + widget.nominalPinjaman
              : rekening['saldo'] + widget.nominalPinjaman;

          noRekPengguna = rekening['no_rek'];
        });
      } else {
        print('Rekening pengguna tidak ditemukan');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9), // Background color for the card
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/Pinjaman.png',
                        color: Colors.green,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Nominal Pinjaman',
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
                    currencyFormat.format(widget.nominalPinjaman),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.wallet,
                        color: Colors.green, // Red color for wallet icon
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Saldo Anda Akan Menjadi',
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
                    currencyFormat.format(saldoAkhir),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton(
                onPressed: () {
                  NavigatorManager.navigatorKey.currentState?.pushNamed(
                    '/InputPinPinjaman',
                    arguments: {
                      'title': '',
                      'userSlug': widget.userSlug,
                      'noRekPengguna': widget.noRekPengguna,
                      'nominalPinjaman': widget.nominalPinjaman,
                      'tenor': widget.tenor,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjut',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
