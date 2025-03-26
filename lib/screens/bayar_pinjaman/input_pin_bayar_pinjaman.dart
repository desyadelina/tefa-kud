// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class InputPinBayarPinjaman extends StatefulWidget {
  final String title;
  final String userSlug;
  final String noRekPengguna;
  final double nominalBayarPinjaman;
  final String tenor;

  const InputPinBayarPinjaman({
    Key? key,
    required this.title,
    required this.userSlug,
    required this.noRekPengguna,
    required this.nominalBayarPinjaman,
    required this.tenor,
  }) : super(key: key);

  @override
  State<InputPinBayarPinjaman> createState() => _InputPinBayarPinjamanState();
}

class _InputPinBayarPinjamanState extends State<InputPinBayarPinjaman> {
  final TextEditingController _pinController = TextEditingController();
  String _pin = '';
  final int pinLength = 6;
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocusNode);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

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

    try {
      var response = await transactionService.konfirmasiRekening(
          widget.userSlug, widget.noRekPengguna, _pin);
      if (response != null &&
          response['message'] == 'Rekening berhasil dikonfirmasi') {
        await transactionService.pembayaran(
          widget.userSlug,
          widget.noRekPengguna,
          widget.nominalBayarPinjaman,
        );

        NavigatorManager.navigatorKey.currentState?.pushNamed(
          '/ReceiptBayarPinjaman',
          arguments: {
            'title': 'Selesai',
            'nominal': widget.nominalBayarPinjaman.toString(),
            'date': DateTime.now().toString(),
            'noRekPengguna': widget.noRekPengguna,
            'userSlug': widget.userSlug,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal mengkonfirmasi PIN: ${response?['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pin yang anda masukkan salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
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
                    color: Colors.grey.withOpacity(0.2), // Perbaikan shadow
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Calendar-Money.png',
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
                  const SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(_pinFocusNode),
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pinLength,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 12.0,
                                ),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: index < _pin.length
                                      ? const Color(0xFF43964F)
                                      : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            focusNode: _pinFocusNode,
                            autofocus: true,
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _pin.length == pinLength ? Colors.black : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _pin.length == pinLength ? _confirmPin : null,
              child: const Text(
                'Lanjut',
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
}
