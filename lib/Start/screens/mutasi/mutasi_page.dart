// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk NumberFormat
import 'package:tefa_kud/services/getUserAccount.dart';

class MutasiPage extends StatefulWidget {
  final String titleBar;
  final Color background;

  const MutasiPage({
    super.key,
    required this.titleBar,
    required this.background,
  });

  @override
  State<MutasiPage> createState() => _MutasiPageState();
}

class _MutasiPageState extends State<MutasiPage> {
  final UserAccountService _userAccountService = UserAccountService();

  bool _isLoading = true;

  double saldo = 0.0;
  String nomorRekening = '';
  String namaPengguna = '';
  List<dynamic> riwayatTransaksi = [];
  String formattedCurrency = '';
  bool isSaldoVisible = true;

  @override
  void initState() {
    super.initState();
    _getUserAccount();

    // Format currency
    formattedCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(saldo);
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      riwayatTransaksi = []; // Clear existing transactions
    });

    await _getUserAccount();
  }

  Future<void> _getUserAccount() async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      final result = await _userAccountService.getUserAccount(context);

      if (mounted) {
        setState(() {
          saldo = result['saldo'];
          nomorRekening = result['nomorRekening'];
          namaPengguna = result['namaPengguna'];
          riwayatTransaksi = result['riwayatTransaksi'];
          formattedCurrency = result['formattedCurrency'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              child: Column(
                children: [
                  buildFilterButtons(),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Riwayat Transaksi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Hari Ini', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      if (_isLoading)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF43964F),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                "Memuat data transaksi..",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      else
                        ...riwayatTransaksi.map((transaction) {
                          return _buildTransactionItem(
                            namaPengguna,
                            formatTransactionType(
                                transaction['jenis_transaksi']),
                            transaction['nominal_transaksi'],
                            transaction['jenis_transaksi'] == 'kirim_uang' ||
                                    transaction['jenis_transaksi'] ==
                                        'tarik_uang' ||
                                    transaction['jenis_transaksi'] ==
                                        'pembayaran'
                                ? true
                                : false,
                          );
                        }),
                      buildTransactionHistory(),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -15,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
                                      : 'Rp ${'*' * (formattedCurrency.length - 3)}',
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
                                  child: Icon(
                                    isSaldoVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF8D8D8D),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
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
                            Text(nomorRekening),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: nomorRekening));
                                _showFloatingPopup(
                                    context, "Nomor Rekening Disalin");
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
                  ),
                ],
              ),
            ),
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

// Add this helper function
String formatTransactionType(String jenisTransaksi) {
  final Map<String, String> transactionTypes = {
    'kirim_uang': 'Transfer',
    'top_up': 'Isi Saldo',
    'tarik_uang': 'Tarik Tunai',
    'pinjaman': 'Pinjaman',
  };

  return transactionTypes[jenisTransaksi.toLowerCase()] ??
      toBeginningOfSentenceCase(jenisTransaksi.replaceAll('_', ' ')) ??
      jenisTransaksi;
}

Widget buildFilterButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: buildFilterButton("Semua"),
      ),
      SizedBox(
        width: 6,
      ),
      Expanded(
        child: buildFilterButton("7 hari terakhir"),
      ),
      SizedBox(
        width: 6,
      ),
      Expanded(
        child: buildFilterButton("1 bulan terakhir"),
      ),
    ],
  );
}

Widget buildFilterButton(String label) {
  return ElevatedButton(
    onPressed: () {
      print("Filter ditekan: $label");
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF43964F).withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget buildTransactionHistory() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Text(
      //   'Riwayat Transaksi',
      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      // ),
      // const SizedBox(height: 8),
      // Text('Kemarin', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 16),
      Text('Minggu Kemarin', style: TextStyle(color: Colors.grey)),
      _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      const SizedBox(height: 16),
      Text('1 Oktober 2024', style: TextStyle(color: Colors.grey)),
      _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
    ],
  );
}

Widget _buildTransactionItem(
    String name, String type, int amount, bool isDebit) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(
          isDebit ? Icons.arrow_upward : Icons.account_balance_wallet,
          color: isDebit ? Colors.red : Colors.green,
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(type, style: TextStyle(color: Colors.grey)),
          ],
        ),
        Spacer(),
        Text(
          '${isDebit ? '-' : '+'} Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}',
          style: TextStyle(
            color: isDebit ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
