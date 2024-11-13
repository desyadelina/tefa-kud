// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/Start/screens/isi_saldo/confirm_isi_saldo.dart';
import 'package:tefa_kud/Start/screens/tarik_tunai/confirm_tarik_tunai.dart';

class TarikTunaiPage extends StatefulWidget {
  const TarikTunaiPage({super.key, required String title});

  @override
  State<TarikTunaiPage> createState() => _TarikTunaiPageState();
}

class _TarikTunaiPageState extends State<TarikTunaiPage> {
  double tariktunai = 10000000000;
  final String nomorRekening = '1283 1234 1234';
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  final TextEditingController _nominalController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Format saldo ke dalam format rupiah setelah inisialisasi
    formattedCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(tariktunai);

    // Tambahkan listener pada controller
    _nominalController.addListener(_onNominalChanged);
  }

  void _onNominalChanged() {
    final text = _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isNotEmpty) {
      final formattedText = NumberFormat('#,###').format(int.parse(text));
      _nominalController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    setState(() {
      isButtonEnabled = text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nominalController.removeListener(_onNominalChanged);
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("dummy appbar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo Sekarang',
                    style: TextStyle(color: Color(0xFF8D8D8D)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            isSaldoVisible
                                ? formattedCurrency
                                : 'Rp ${'*' * (formattedCurrency.length - 3)}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSaldoVisible = !isSaldoVisible;
                              });
                            },
                            child: Icon(
                              isSaldoVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF8D8D8D),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF43964F),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(nomorRekening),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: nomorRekening));
                          _showFloatingPopup(context, "Nomor Rekening Disalin");
                        },
                        child: Icon(
                          Icons.copy,
                          color: const Color(0xFF8D8D8D),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.moneyBillTransfer,
                        color: Color(0xFF43964F),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Nominal Isi Saldo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF43964F),
                          fontWeight: FontWeight.bold,
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _nominalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Only digits allowed
                            LengthLimitingTextInputFormatter(
                                12), // Limit to 12 characters
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        String nominal = _nominalController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConfirmTarikTunai(
                              title: '',
                            ),
                          ),
                        );
                        print('Nominal isi saldo: $nominal');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isButtonEnabled ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjut',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFloatingPopup(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.5,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }
}
