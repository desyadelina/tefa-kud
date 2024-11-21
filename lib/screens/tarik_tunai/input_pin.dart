// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tefa_kud/screens/isi_saldo/receipt_isi_saldo.dart';
import 'package:tefa_kud/screens/tarik_tunai/receipt_tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/receipt_transfer.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class InputPinTarikTunai extends StatefulWidget {
  final String title;
  final String userSlug;
  final String noRekPengguna;
  final String namaPengguna;
  final double nominalTarikTunai;
  const InputPinTarikTunai(
      {Key? key,
      required this.title,
      required this.userSlug,
      required this.noRekPengguna,
      required this.namaPengguna,
      required this.nominalTarikTunai})
      : super(key: key);

  @override
  State<InputPinTarikTunai> createState() => _InputPinTarikTunaiState();
}

class _InputPinTarikTunaiState extends State<InputPinTarikTunai> {
  final TextEditingController _pinController = TextEditingController();
  String _pin = '';
  final int pinLength = 6;

  void _onPinChanged(String value) {
    setState(() {
      _pin = value;
    });
  }

  Future<void> _confirmPin() async {
    AuthService authService = AuthService();
    TransactionService transactionService = TransactionService();

    String? storedPin = await authService.storage.read(key: 'pin');
    print('Stored PIN: $storedPin');
    print('Entered PIN: $_pin');
    print(
        'Slug: ${widget.userSlug}, Rekening: ${widget.noRekPengguna}, PIN: $_pin');

    var response = await transactionService.konfirmasiRekening(
        widget.userSlug, widget.noRekPengguna, _pin);
    if (response != null &&
        response['message'] == 'Rekening berhasil dikonfirmasi') {
      await transactionService.tarikUang(
        widget.userSlug,
        widget.noRekPengguna,
        widget.nominalTarikTunai,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptTarikTunai(
            title: 'Selesai',
            nominal: widget.nominalTarikTunai.toString(),
            date: DateTime.now().toString(),
            namaPengguna: widget.namaPengguna,
            noRekPengguna: widget.noRekPengguna,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal mengkonfirmasi PIN: ${response?['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("dummy appbar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Pay-Money.png',
                    height: 120,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Konfirmasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silakan masukkan PIN Anda\nuntuk melanjutkan transaksi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pinLength, (index) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: index < _pin.length
                                ? const Color(
                                    0xFF43964F) // Warna hijau ketika ada input
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: _pinController,
                    maxLength: pinLength,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.transparent),
                    cursorColor: Colors.transparent,
                    showCursor: false,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: _onPinChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _pin.length == pinLength
                    ? Colors.black // Warna hitam ketika PIN lengkap
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _pin.length == pinLength ? _confirmPin : null,
              child: const Text(
                'Selesai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
    _pinController.dispose();
    super.dispose();
  }
}
