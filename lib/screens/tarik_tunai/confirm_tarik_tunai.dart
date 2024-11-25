// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/screens/isi_saldo/input_pin_isi_saldo.dart';
import 'package:tefa_kud/screens/tarik_tunai/input_pin_tarik_tunai.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class ConfirmTarikTunai extends StatefulWidget {
  final String title;
  final double nominalTarikTunai;
  final String noRekPengguna;
  final String userSlug;
  const ConfirmTarikTunai(
      {super.key,
      required this.title,
      required this.nominalTarikTunai,
      required this.noRekPengguna,
      required this.userSlug});

  @override
  State<ConfirmTarikTunai> createState() => _ConfirmTarikTunaiState();
}

class _ConfirmTarikTunaiState extends State<ConfirmTarikTunai>
    with WidgetsBindingObserver {
  String? noRekPengguna;
  String? namaPengguna;
  double saldoAkhir = 0.0; // Example value
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
      namaPengguna = currentUser['nama_pengguna'];
      String slug = currentUser['slug'];

      var rekeningData = await transactionService.getRekeningPengguna(
          slug, widget.noRekPengguna);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          saldoAkhir = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble() - widget.nominalTarikTunai
              : rekening['saldo'] - widget.nominalTarikTunai;
        });

        noRekPengguna = rekening['no_rek'];
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
        padding: const EdgeInsets.all(16.0), // Padding to avoid screen edges
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
                        'assets/images/Transfer.png',
                        color: Colors.green,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Nominal Tarik Tunai',
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
                    currencyFormat.format(widget.nominalTarikTunai),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputPinTarikTunai(
                        title: '',
                        userSlug: widget.userSlug,
                        noRekPengguna: widget.noRekPengguna,
                        namaPengguna: namaPengguna ?? 'Unknown',
                        nominalTarikTunai: widget.nominalTarikTunai,
                      ),
                    ),
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
