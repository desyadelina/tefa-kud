// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:tefa_kud/screens/isi_saldo/receipt_isi_saldo.dart';
import 'package:tefa_kud/screens/transfer/receipt_transfer.dart';

class InputPinTarikTunai extends StatefulWidget {
  const InputPinTarikTunai({Key? key, required String title}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("dummy appbar"),
      ),
      body: ListView(
        children: [
          Padding(
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                  onPressed: _pin.length == pinLength
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('PIN Diterima, Transaksi Berhasil!'),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptIsiSaldo(
                                nominal: '',
                                date: '',
                              ),
                            ),
                          );
                        }
                      : null,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
