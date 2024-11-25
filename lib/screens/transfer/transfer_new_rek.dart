// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/transfer/input_nominal_transfer.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
class TransferNewRek extends StatefulWidget {
  final String title;
  const TransferNewRek({Key? key, required this.title}) : super(key: key);

  @override
  State<TransferNewRek> createState() => _TransferNewRekState();
}

class _TransferNewRekState extends State<TransferNewRek> {
  final TextEditingController _rekeningTujuanController =
      TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _rekeningTujuanController.addListener(_onTextChanged);
  }

  // Fungsi untuk menambahkan spasi setiap 4 digit
  String _formatText(String text) {
    text = text.replaceAll(' ', ''); // Hapus semua spasi
    List<String> groups = [];
    for (int i = 0; i < text.length; i += 4) {
      groups.add(text.substring(i, i + 4 > text.length ? text.length : i + 4));
    }
    return groups.join(' ');
  }

  // Fungsi yang dipanggil saat teks berubah
  void _onTextChanged() {
    String formattedText = _formatText(_rekeningTujuanController.text);
    _rekeningTujuanController.value = _rekeningTujuanController.value.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );

    // Aktifkan tombol hanya jika teks berisi 12 digit (tanpa spasi)
    setState(() {
      isButtonEnabled =
          _rekeningTujuanController.text.replaceAll(' ', '').length == 12;
    });
  }

  Future<void> _prosesKirimUang() async {
    String rekeningTujuan = _rekeningTujuanController.text.replaceAll(' ', '');
    TransactionService transactionService = TransactionService();

    String? userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData = await transactionService.getRekeningPengguna(userSlug, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    String noRekPengguna = rekeningData[0]['no_rek'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputNominalTransfer(
          title: 'Input Nominal',
          rekeningTujuan: rekeningTujuan,
          userSlug: userSlug,
          noRekPengguna: noRekPengguna,
        ),
      ),
    );
  }

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
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.userGroup,
                        color: Color(0xFF43964F),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Rekening Tujuan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF43964F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _rekeningTujuanController,
                      maxLength: 14,
                      decoration: const InputDecoration(
                        hintText: 'xxxx xxxx xxxx',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? Colors.black : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isButtonEnabled
                  ? () {
                      String accountNumber =
                          _rekeningTujuanController.text.replaceAll(' ', '');
                      NavigatorManager.navigatorKey.currentState
                          ?.pushNamed('/InputNominalTransfer');
                      print('Nomor rekening: $accountNumber');
                    }
                  : null,
              child: const Text(
                "Lanjut",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rekeningTujuanController.removeListener(_onTextChanged);
    _rekeningTujuanController.dispose();
    super.dispose();
  }
}
