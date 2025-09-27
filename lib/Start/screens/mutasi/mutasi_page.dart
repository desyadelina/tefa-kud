// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk NumberFormat
import 'package:tefa_kud/services/getUserAccount.dart';
import 'package:tefa_kud/widget/rekeningCard.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth >= 412
        ? 16
        : (14 - ((412 - screenWidth) / 2)).clamp(12, 16);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: const Color.fromARGB(223, 255, 255, 255),
        color: const Color(0xFF43964F),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFF43964F),
              expandedHeight: 78.0,
              toolbarHeight: 0,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: const EdgeInsetsDirectional.only(bottom: 0),
                title: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 26),
                        child: Text(
                          "Mutasi",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height,
                        height: 200,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 100),
                            padding: const EdgeInsets.only(top: 60),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal:
                                    MediaQuery.of(context).size.width <= 412
                                        ? (MediaQuery.of(context).size.width /
                                                412 *
                                                18)
                                            .clamp(8, 32)
                                        : 32,
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: _isLoading
                                            ? Column(
                                                children: List.generate(
                                                  5,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 16),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 120,
                                                              height: 16,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Container(
                                                              width: 80,
                                                              height: 14,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          width: 100,
                                                          height: 16,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Riwayat Transaksi',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text('Hari Ini',
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                      ),
                                      ...riwayatTransaksi.map((transaction) {
                                        return _buildTransactionItem(
                                          namaPengguna,
                                          formatTransactionType(
                                              transaction['jenis_transaksi']),
                                          transaction['nominal_transaksi'],
                                          transaction['jenis_transaksi'] ==
                                                      'kirim_uang' ||
                                                  transaction[
                                                          'jenis_transaksi'] ==
                                                      'tarik_uang' ||
                                                  transaction[
                                                          'jenis_transaksi'] ==
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
                            top: 10,
                            left: 0,
                            right: 0,
                            child: rekeningCard(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildTransactionItem(
      String name, String type, int amount, bool isDebit) {
    double screenWidth = MediaQuery.of(context).size.width;
    final int maxChars = screenWidth < 372 ? 24 : 30;
    double fontSize = screenWidth >= 412
        ? 16
        : (14 - ((412 - screenWidth) / 2)).clamp(12, 16);

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
              Text(
                name.length > maxChars
                    ? '${name.substring(0, maxChars)}...'
                    : name,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                type,
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${isDebit ? '-' : '+'} Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}',
            style: TextStyle(
              color: isDebit ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
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
      // const SizedBox(height: 16),
      // Text('Minggu Kemarin', style: TextStyle(color: Colors.grey)),
      // _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      // _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      // const SizedBox(height: 16),
      // Text('1 Oktober 2024', style: TextStyle(color: Colors.grey)),
      // _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
      // _buildTransactionItem('Seila Salsabiela', 'Transfer', -10000000, true),
    ],
  );
}
