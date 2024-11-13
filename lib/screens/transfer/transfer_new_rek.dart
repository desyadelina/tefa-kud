// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tefa_kud/screens/transfer/input_nominal_transfer.dart';

class TransferNewRek extends StatefulWidget {
  final String title;
  const TransferNewRek({Key? key, required this.title}) : super(key: key);

  @override
  State<TransferNewRek> createState() => _TransferNewRekState();
}

class _TransferNewRekState extends State<TransferNewRek> {
  final TextEditingController _accountController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_onTextChanged);
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
    String formattedText = _formatText(_accountController.text);
    _accountController.value = _accountController.value.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );

    // Aktifkan tombol hanya jika teks berisi 12 digit (tanpa spasi)
    setState(() {
      isButtonEnabled =
          _accountController.text.replaceAll(' ', '').length == 12;
    });
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        controller: _accountController,
                        maxLength: 14, // Maksimal termasuk spasi untuk 12 digit
                        decoration: const InputDecoration(
                          hintText: 'xxxx xxxx xxxx',
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
                            _accountController.text.replaceAll(' ', '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputNominalTransfer(
                                title: 'Input Nominal'),
                          ),
                        );
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
      ),
    );
  }

  @override
  void dispose() {
    _accountController.removeListener(_onTextChanged);
    _accountController.dispose();
    super.dispose();
  }
}
