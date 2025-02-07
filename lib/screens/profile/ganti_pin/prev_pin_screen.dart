// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/profile/ganti_pin/new_pin_screen.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class PreviousPinPage extends StatefulWidget {
  final String title;
  final String userSlug;
  final String noRekPengguna;
  const PreviousPinPage({
    Key? key,
    required this.title,
    required this.userSlug,
    required this.noRekPengguna,
  }) : super(key: key);

  @override
  State<PreviousPinPage> createState() => _PreviousPinPageState();
}

class _PreviousPinPageState extends State<PreviousPinPage> {
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

    String? storedPin =
        await authService.storage.read(key: AuthService.KEY_PIN);
    print('Stored PIN: $storedPin');
    print('Entered PIN: $_pin');
    print(
        'Slug: ${widget.userSlug}, Rekening: ${widget.noRekPengguna}, PIN: $_pin');

    if (storedPin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stored PIN not found')),
      );
      return;
    }

    bool isPinValid =
        await authService.konfirmasiPengguna(widget.userSlug, _pin);

    if (isPinValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPinPage(
            title: 'Ganti PIN Baru',
            userSlug: widget.userSlug,
            noRekPengguna: widget.noRekPengguna,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN yang Anda masukkan salah')),
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
                    color: Colors.white,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Phone-lock.png',
                    height: 120,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Konfirmasi PIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silakan konfirmasi \nPIN yang anda gunakan saat ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Adjust width as needed
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
                                    horizontal: 8.0, vertical: 12.0),
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
