import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http; // Pastikan ini diimpor
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tefa_kud/services/rekening_service.dart';
import 'package:tefa_kud/widget/rekeningSelectionModal.dart';

class RekeningCard extends StatefulWidget {
  final int saldo;
  final String nomorRekening;
  final bool initialSaldoVisible;
  final List<Map<String, dynamic>> rekeningList; // List data semua rekening

  const RekeningCard({
    super.key,
    this.saldo = 0,
    required this.nomorRekening,
    required this.initialSaldoVisible,
    required this.rekeningList,
  });

  @override
  _RekeningCardState createState() => _RekeningCardState();
}

class _RekeningCardState extends State<RekeningCard> {
  late bool isSaldoVisible;
  final rekeningService = RekeningService();
  late Future<Map<String, dynamic>?> _rekeningFuture;

  @override
  void initState() {
    super.initState();
    isSaldoVisible = widget.initialSaldoVisible;
  }

  Future<void> saveSelectedRekening(String noRek) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('no_rek', noRek);
  }

  @override
  Widget build(BuildContext context) {
    String formattedCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.saldo);

    return Container(
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
                        : 'Rp ${'*' * formattedCurrency.replaceAll(RegExp(r'[^0-9]'), '').length}',
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
                    child: SvgPicture.asset(
                      "assets/icon/View.svg",
                      color: const Color(0xFF8D8D8D),
                      width: 20,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showRekeningSelectionModal(context);
                },
                child: Icon(Icons.keyboard_arrow_down),
              ),
              Container(
                //ini dijadikan tombol dropdown atau popup untuk melihat list rekening yang ada pada slug tersebut
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF43964F),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(widget.nomorRekening),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.nomorRekening));
                  _showFloatingPopup(context, "Nomor Rekening Disalin");
                },
                child: const Icon(
                  Icons.copy,
                  color: Color(0xFF8D8D8D),
                  size: 16,
                ),
              ),
            ],
          ),
        ],
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
              color: Colors.black.withOpacity(1),
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

    Future.delayed(const Duration(milliseconds: 2000), () {
      overlayEntry.remove();
    });
  }

  void _showRekeningSelectionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RekeningSelectionModal(
          rekeningList: widget.rekeningList,
          onRekeningSelected: (selectedRekening) async {
            await saveSelectedRekening(selectedRekening);

            // Perbarui UI secara lokal tanpa panggilan API
            setState(() {
              isSaldoVisible = true; // Contoh update UI lokal
            });
          },
        );
      },
    );
  }
}
