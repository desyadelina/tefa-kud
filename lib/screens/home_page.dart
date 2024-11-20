// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/pinjaman/pinjaman.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';
import 'package:tefa_kud/services/rekening_service.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:tefa_kud/widget/rekening_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final RekeningService rekeningService = RekeningService();
  late Future<Map<String, dynamic>?> _rekeningFuture;

  double saldo = 17500000;
  final String nomorRekening = '1283 1234 1234';
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  double _appBarOpacity = 1.0;

  void loadRekening() async {
    try {
      final rekening = await rekeningService.getSelectedOrFirstRekening();
      if (rekening != null) {
        print("Rekening yang dipilih: ${rekening['no_rek']}");
        setState(() {
          _rekeningFuture = Future.value(rekening);
        });
      } else {
        print("Tidak ada rekening yang tersedia.");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _rekeningFuture = Future.error("Gagal memuat data rekening");
      });
    }
  }

  @override
  void initState() {
    super.initState();

    formattedCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(saldo);

    _rekeningFuture = rekeningService.getSelectedOrFirstRekening();

    loadRekening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF43964F),
            expandedHeight: 78.0,
            toolbarHeight: 55,
            floating: true,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, top: 24),
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
                                image: AssetImage('assets/images/Location.png'),
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
                    Column(
                      children: [
                        Container(
                          height: 100,
                          color: const Color(0xFF43964F),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical: 0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Transaksi terkini',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Hari ini',
                                      style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 16.0),
                                  Card(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Transfer',
                                              -10000000,
                                              true),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Isi saldo',
                                              10000000,
                                              false),
                                          _buildTransactionItem('Selai Apel',
                                              'Isi saldo', 30000000, false),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Transfer',
                                              -10000000,
                                              true),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Isi saldo',
                                              10000000,
                                              false),
                                          _buildTransactionItem('Selai Apel',
                                              'Isi saldo', 30000000, false),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Transfer',
                                              -10000000,
                                              true),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Isi saldo',
                                              10000000,
                                              false),
                                          _buildTransactionItem('Selai Apel',
                                              'Isi saldo', 30000000, false),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Transfer',
                                              -10000000,
                                              true),
                                          _buildTransactionItem(
                                              'Seila Salsabiela',
                                              'Isi saldo',
                                              10000000,
                                              false),
                                          _buildTransactionItem('Selai Apel',
                                              'Isi saldo', 30000000, false),
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
                    Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: FutureBuilder<Map<String, dynamic>?>(
                              future: _rekeningFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Menampilkan indikator loading
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 12),
                                        Text("Memuat data Rekening"),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  final rekeningData = snapshot.data!;

                                  // Cek apakah 'data' ada dan berbentuk List
                                  final List<Map<String, dynamic>>
                                      allRekeningData =
                                      (rekeningData['data'] as List?)
                                              ?.cast<Map<String, dynamic>>() ??
                                          [];

                                  return RekeningCard(
                                    saldo: rekeningData['saldo'] ?? 0,
                                    nomorRekening: rekeningData['no_rek'] ?? '',
                                    initialSaldoVisible: true,
                                    rekeningList: allRekeningData,
                                  );
                                } else {
                                  // Menampilkan pesan jika data tidak ada
                                  return Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                            "Gagal Memuat data Rekening"),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          onPressed: () {
                                            loadRekening();
                                          },
                                          child:
                                              const Text("Tekan untuk refresh"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFloatingPopup(BuildContext context, String message,
      {Color backgroundColor = Colors.black, int duration = 2500}) {
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
              color: backgroundColor.withOpacity(0.8),
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
    Future.delayed(Duration(milliseconds: duration), () {
      overlayEntry.remove();
    });
  }
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
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              '${isDebit ? '-' : '+'} Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}',
              style: TextStyle(
                color: isDebit ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, // Membatasi teks dalam satu baris
              minFontSize: 6, // Ukuran font minimum agar tetap terbaca
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
