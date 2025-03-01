// ignore_for_file: depend_on_referenced_packages, annotate_overrides, prefer_const_constructors, duplicate_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/screens/transfer/confirm_page_transfer.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:tefa_kud/screens/transfer/confirm_page_transfer.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/widget/saldoCard.dart';

class InputNominalTransfer extends StatefulWidget {
  final String title;
  final String rekeningTujuan;
  final String userSlug;
  final String noRekPengguna;

  const InputNominalTransfer({
    super.key,
    required this.title,
    required this.rekeningTujuan,
    required this.userSlug,
    required this.noRekPengguna,
  });

  @override
  State<InputNominalTransfer> createState() => _InputNominalTransferState();
}

class _InputNominalTransferState extends State<InputNominalTransfer> {
  double saldo = 0.0;
  String nomorRekening = '';
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  final TextEditingController _nominalController = TextEditingController();
  bool isButtonEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getUserAccount();
    _nominalController.addListener(_onNominalChanged);
  }

  // jangan otak-atik kode di bawah ini
  Future<void> _getUserAccount() async {
    TransactionService transactionService = TransactionService();
    try {
      var rekeningData = await transactionService.getRekeningPengguna(
          widget.userSlug, widget.noRekPengguna);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          saldo = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble()
              : rekening['saldo'];
          nomorRekening = rekening['no_rek'];
          formattedCurrency = NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(saldo);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rekening tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data rekening: ${e.toString()}')),
      );
    }
  }
  // end

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

  // jangan otak-atik kode di bawah ini
  void _proceedToConfirm() {
    double nominalTransaksi = double.tryParse(
            _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0.0;

    if (nominalTransaksi > 0 && nominalTransaksi <= saldo) {
      NavigatorManager.navigatorKey.currentState?.pushNamed(
        '/ConfirmTransfer',
        arguments: {
          'title': 'Konfirmasi Transfer',
          'nominalTransfer': nominalTransaksi,
          'noRekPengguna': nomorRekening,
          'noRekTujuan': widget.rekeningTujuan,
          'userSlug': widget.userSlug,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nominal tidak valid atau melebihi saldo')),
      );
    }
  }
  // end

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.only(top: 100),
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
              children: [
                const SizedBox(height: 20),
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
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.moneyBillTransfer,
                            color: Color(0xFF43964F),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Nominal Transfer',
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
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // jangan otak-atik kode di bawah ini
                    onPressed: isButtonEnabled ? _proceedToConfirm : null,
                    // end
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          isButtonEnabled ? Colors.black : Colors.grey,
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
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: saldoCard(
            isLoading: _isLoading,
            formattedCurrency: formattedCurrency,
            nomorRekening: nomorRekening,
            isSaldoVisible: isSaldoVisible,
            onVisibilityToggle: () {
              setState(() {
                isSaldoVisible = !isSaldoVisible;
              });
            },
            showFloatingPopup: _showFloatingPopup,
          ),
        ),
      ],
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
