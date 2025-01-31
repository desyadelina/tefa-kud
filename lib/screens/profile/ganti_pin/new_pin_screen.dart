// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/profile/ganti_pin/new_pin_screen.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';

class NewPinPage extends StatefulWidget {
  final String title;
  final String userSlug;
  final String noRekPengguna;
  const NewPinPage({
    Key? key,
    required this.title,
    required this.userSlug,
    required this.noRekPengguna,
  }) : super(key: key);

  @override
  State<NewPinPage> createState() => _NewPinPageState();
}

class _NewPinPageState extends State<NewPinPage> {
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

// jangan otak-atik kode di bawah ini
  // Future<void> _confirmPin() async {
  //   AuthService authService = AuthService();
  //   TransactionService transactionService = TransactionService();

  //   String? storedPin = await authService.storage.read(key: 'pin');
  //   print('Stored PIN: $storedPin');
  //   print('Entered PIN: $_pin');
  //   print(
  //       'Slug: ${widget.userSlug}, Rekening: ${widget.noRekPengguna}, PIN: $_pin');

  //   var response = await transactionService.konfirmasiRekening(
  //       widget.userSlug, widget.noRekPengguna, _pin);
  //   if (response != null &&
  //       response['message'] == 'Rekening berhasil dikonfirmasi') {
  //     await transactionService.pinjaman(
  //       widget.userSlug,
  //       widget.noRekPengguna,
  //       widget.nominalPinjaman,
  //       widget.tenor,
  //     );

  //     NavigatorManager.navigatorKey.currentState?.pushNamed(
  //       '/CodePinjaman',
  //       arguments: {
  //         'title': 'Selesai',
  //         'nominal': widget.nominalPinjaman.toString(),
  //         'date': DateTime.now().toString(),
  //         'noRekPengguna': widget.noRekPengguna,
  //         'tenor': widget.tenor,
  //       },
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Gagal mengkonfirmasi PIN: ${response?['message']}')),
  //     );
  //   }
  // }

  // end
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
                  'PIN Terbaru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masukkan\nPIN terbaru Anda untuk melanjutkan',
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
            // onPressed: _pin.length == pinLength ? _confirmPin : null,
            //direct ke NewPinPage
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Klik di luar dialog tidak akan menutup dialog
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.white, // Background dialog putih
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60.0,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Pin Berhasil diperbarui!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Warna teks hitam
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Silakan gunakan pin terbaru untuk akses berikutnya.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(
                                  0xFF8D8D8D), // Warna teks abu-abu (#8D8D8D)
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black, // Warna latar tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainLayout(
                                    title: '',
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Kembali ke Beranda',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
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
    );
  }
}
