// ignore_for_file: depend_on_referenced_packages, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/Start/screens/transfer/confirm_pin_transfer.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class ConfirmTransfer extends StatefulWidget {
  final String title;
  final double nominalTransfer;
  String noRekPengguna;
  final String noRekTujuan;
  ConfirmTransfer({
    super.key,
    required this.title,
    required this.nominalTransfer,
    required this.noRekPengguna,
    required this.noRekTujuan,
  });

  @override
  State<ConfirmTransfer> createState() => _ConfirmTransferState();
}

class _ConfirmTransferState extends State<ConfirmTransfer> {
  String? namaPengirim;
  String? namaPenerima;
  String? noRekPengguna;
  double saldoAkhir = 0.0;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _getPenerimaDetails();
  }

  Future<void> _getUserDetails() async {
    TransactionService transactionService = TransactionService();

    var currentUser = await transactionService.getCurrentUser();
    if (currentUser != null) {
      namaPengirim = currentUser['nama_pengguna'];
      String slug = currentUser['slug'];

      var rekeningData = await transactionService.getRekeningPengguna(slug);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        saldoAkhir = (rekening['saldo'] is int)
            ? (rekening['saldo'] as int).toDouble() - widget.nominalTransfer
            : rekening['saldo'] - widget.nominalTransfer;

        noRekPengguna = rekening['no_rek'];
      }
    }

    await _getPenerimaDetails();
  }

  Future<void> _getPenerimaDetails() async {
    TransactionService transactionService = TransactionService();

    var penerimaData =
        await transactionService.getRekeningPengguna(widget.noRekTujuan);
    if (penerimaData != null && penerimaData.isNotEmpty) {
      var penerima = penerimaData[0];
      setState(() {
        namaPenerima = penerima['nama_pengguna'];
        print('Nama Penerima: $namaPenerima');
      });
    } else {
      print('Rekening penerima tidak ditemukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("dummy appbar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  child: Column(
                    children: const [
                      Text(
                        'Pengirim',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40),
                      FaIcon(FontAwesomeIcons.arrowDown, color: Colors.green),
                      SizedBox(height: 40),
                      Text(
                        'Penerima',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFF43964F),
                              radius: 20,
                              child: FaIcon(
                                FontAwesomeIcons.solidUser,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaPengirim ?? 'Loading...',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  widget.noRekPengguna,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFF43964F),
                              radius: 20,
                              child: FaIcon(
                                FontAwesomeIcons.solidUser,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaPenerima ?? 'Loading...',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  widget.noRekTujuan,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9F9F9),
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
                        'Nominal Transfer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    currencyFormat.format(widget.nominalTransfer),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.wallet, color: Color(0xFFD02727)),
                      const SizedBox(width: 8),
                      const Text(
                        'Saldo anda akan menjadi',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(saldoAkhir),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ConfirmationPinTransfer(title: 'Input Nominal'),
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
            ),
          ],
        ),
      ),
    );
  }
}
