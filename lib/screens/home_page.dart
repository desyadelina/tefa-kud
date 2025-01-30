// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:tefa_kud/widget/rekeningCard.dart';
import 'package:tefa_kud/services/getUserAccount.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //Mengambil widget dari halaman lain yang diimpor
  final UserAccountService _userAccountService = UserAccountService();
  bool _isLoading = true;

  double saldo = 0.0;
  String nomorRekening = '';
  String namaPengguna = '';
  List<dynamic> riwayatTransaksi = [];
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _getUserAccount();
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

  Future<void> _onRefresh() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      riwayatTransaksi = []; // Clear existing transactions
    });

    await _getUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF43964F),
              expandedHeight: 78.0,
              toolbarHeight: 60,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding:
                    const EdgeInsetsDirectional.only(start: 16, top: 44),
                title: Opacity(
                  opacity: _appBarOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                              'assets/logo/koperasi-indonesia-seeklogo.png'),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Koperasi Unit Desa",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Image(
                                  image:
                                      AssetImage('assets/images/Location.png'),
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Banjarbaru",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                background: Container(
                  color: const Color(0xFF43964F),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        color: const Color(0xFF43964F),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              )),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 56),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          iconMenuButton(
                                            'Transfer',
                                            'assets/images/Transfer.png',
                                            () {
                                              NavigatorManager
                                                  .navigatorKey.currentState
                                                  ?.pushNamed('/transfer');
                                            },
                                          ),
                                          iconMenuButton(
                                            'Isi saldo',
                                            'assets/images/Isi Saldo.png',
                                            () {
                                              NavigatorManager
                                                  .navigatorKey.currentState
                                                  ?.pushNamed('/isiSaldo');
                                            },
                                          ),
                                          iconMenuButton(
                                            'Tarik tunai',
                                            'assets/images/Tarik Tunai.png',
                                            () {
                                              NavigatorManager
                                                  .navigatorKey.currentState
                                                  ?.pushNamed('/tarikTunai');
                                            },
                                          ),
                                          iconMenuButton(
                                            'Pinjaman',
                                            'assets/images/Pinjaman.png',
                                            () {
                                              NavigatorManager
                                                  .navigatorKey.currentState
                                                  ?.pushNamed('/pinjaman');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Container(
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/banner/Banner-1.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Transaksi terkini',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text('Hari ini',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        const SizedBox(height: 16.0),
                                        Card(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          elevation: 4.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (_isLoading)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 40),
                                                    width: double.infinity,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          color:
                                                              Color(0xFF43964F),
                                                        ),
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                        Text(
                                                          "Memuat data transaksi..",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                else
                                                  ...riwayatTransaksi
                                                      .map((transaction) {
                                                    return _buildTransactionItem(
                                                      namaPengguna,
                                                      formatTransactionType(
                                                          transaction[
                                                              'jenis_transaksi']),
                                                      transaction[
                                                          'nominal_transaksi'],
                                                      transaction[
                                                                      'jenis_transaksi'] ==
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
                                                  })
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showFloatingPopup(BuildContext context, String message) {
    // Membuat overlay
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

    // Menghilangkan popup setelah 2 detik
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
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(type, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
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
