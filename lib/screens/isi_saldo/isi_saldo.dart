// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/isi_saldo/confirm_isi_saldo.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:tefa_kud/widget/saldoCard.dart';

class IsiSaldoPage extends StatefulWidget {
  const IsiSaldoPage({super.key, required String title});

  @override
  State<IsiSaldoPage> createState() => _IsiSaldoPageState();
}

class _IsiSaldoPageState extends State<IsiSaldoPage> {
  double isisaldo = 0.0;
  String nomorRekening = '';
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  final TextEditingController _nominalController = TextEditingController();
  bool isButtonEnabled = false;
  bool _isLoading = false;
  String? noRekPengguna;

  @override
  void initState() {
    super.initState();
    _getUserAccount();
    _nominalController.addListener(_onNominalChanged);
  }

  Future<void> _getUserAccount() async {
    setState(() {
      _isLoading = true;
    });

    TransactionService transactionService = TransactionService();

    try {
      String? userSlug = await transactionService.getUserSlug();

      if (userSlug == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
        );
        return;
      }

      var rekeningData =
          await transactionService.getRekeningPengguna(userSlug, '');
      if (rekeningData == null || rekeningData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rekening tidak ditemukan')),
        );
        return;
      }

      String noRekPengguna = rekeningData[0]['no_rek'];
      var detailRekening =
          await transactionService.getRekeningPengguna(userSlug, noRekPengguna);

      if (detailRekening != null && detailRekening.isNotEmpty) {
        var rekening = detailRekening[0];
        setState(() {
          isisaldo = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble()
              : rekening['saldo'];
          nomorRekening = rekening['no_rek'];
          formattedCurrency = NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(isisaldo);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rekening tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data rekening: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      setState(() {
        _isLoading = true; // Reset loading state when returning to this page
      });
    }
  }

  Future<void> _proceedToConfirm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      double nominalTransaksi = double.tryParse(
              _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0;
      TransactionService transactionService = TransactionService();

      String? userSlug = await transactionService.getUserSlug();

      if (userSlug == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
        );
        return;
      }

      var rekeningData =
          await transactionService.getRekeningPengguna(userSlug, '');
      if (rekeningData == null || rekeningData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rekening tidak ditemukan')),
        );
        return;
      }

      if (nominalTransaksi > 0) {
        await NavigatorManager.navigatorKey.currentState?.pushNamed(
          '/ConfirmIsiSaldo',
          arguments: {
            'title': 'Konfirmasi Transfer',
            'nominalIsiSaldo': nominalTransaksi,
            'noRekPengguna': nomorRekening,
            'userSlug': userSlug,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nominal tidak valid')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
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
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
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
                    onPressed: (_isLoading || isButtonEnabled)
                        ? _proceedToConfirm
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          isButtonEnabled ? Colors.black : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
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
