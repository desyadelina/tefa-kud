// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/screens/isi_saldo/input_pin_isi_saldo.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class ConfirmIsiSaldo extends StatefulWidget {
  final String title;
  final double nominalIsiSaldo;
  final String noRekPengguna;
  final String userSlug;
  const ConfirmIsiSaldo(
      {super.key,
      required this.title,
      required this.nominalIsiSaldo,
      required this.noRekPengguna,
      required this.userSlug});

  @override
  State<ConfirmIsiSaldo> createState() => _ConfirmIsiSaldoState();
}

class _ConfirmIsiSaldoState extends State<ConfirmIsiSaldo> {
  String? noRekPengguna;
  String? namaPengguna;
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
      namaPengguna = currentUser['nama_pengguna'];
      String slug = currentUser['slug'];

      var rekeningData = await transactionService.getRekeningPengguna(
          slug, widget.noRekPengguna);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        saldoAkhir = (rekening['saldo'] is int)
            ? (rekening['saldo'] as int).toDouble() - widget.nominalIsiSaldo
            : rekening['saldo'] - widget.nominalIsiSaldo;

        noRekPengguna = rekening['no_rek'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dummy appbar"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
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
                    currencyFormat.format(widget.nominalIsiSaldo),
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
                      builder: (context) => InputPinIsiSaldo(
                        title: '',
                        userSlug: widget.userSlug,
                        noRekPengguna: widget.noRekPengguna,
                        namaPengguna: namaPengguna ?? 'Unknown',
                        nominalIsiSaldo: widget.nominalIsiSaldo,
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
