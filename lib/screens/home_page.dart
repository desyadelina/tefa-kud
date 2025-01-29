// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/list_bayar_pinjaman.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
    TransactionService transactionService = TransactionService();

    String? userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData =
        await transactionService.getRekeningPengguna(userSlug, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    String noRekPengguna = rekeningData[0]['no_rek'];

    try {
      var rekeningData =
          await transactionService.getRekeningPengguna(userSlug, noRekPengguna);
      var riwayatTransaksiData = await transactionService.getTransactionHistory(
          userSlug, noRekPengguna);

      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          saldo = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble()
              : rekening['saldo'];
          nomorRekening = rekening['no_rek'];
          formattedCurrency = NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(saldo);
        });
        if (riwayatTransaksiData != null && riwayatTransaksiData.isNotEmpty) {
          var pengguna = await transactionService
              .getNamaPenggunaByIdRekening(rekening['id']);
          namaPengguna = pengguna?['pengguna'];
          riwayatTransaksi = riwayatTransaksiData
              .where((transaction) =>
                  transaction['status_transaksi'].toString().toLowerCase() !=
                  'pending')
              .toList();
          if (riwayatTransaksi.length > 5) {
            riwayatTransaksi = riwayatTransaksi
                .where((transaction) =>
                    transaction['status_transaksi'].toString().toLowerCase() !=
                    'pending')
                .take(5)
                .toList();
            setState(() {
              this.riwayatTransaksi = riwayatTransaksi;
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rekening tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data rekening: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.axis == Axis.vertical) {
            double offset = scrollInfo.metrics.pixels;
            setState(() {
              _appBarOpacity =
                  offset <= 1 ? 1.0 : (1 - (offset / 100)).clamp(1.0, 1.0);
            });
          }
          return true;
        },
        child: CustomScrollView(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 120,
                                  child: Wrap(
                                    spacing:
                                        16.0, // Space between the buttons horizontally
                                    runSpacing:
                                        16.0, // Space between the rows vertically
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
                                      iconMenuButton(
                                        'Bayar Pinjaman',
                                        'assets/images/Pinjaman.png',
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListBayarPinjaman(
                                                title: '',
                                                totalTagihan: 0,
                                                noRekPengguna: 0,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 80.0),
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      elevation: 4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
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
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 130,
                              color: const Color(0xFFF9F9F9),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Saldo sekarang',
                                    style: TextStyle(color: Color(0xFF8D8D8D)),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              fontFamily: 'RedRose',
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSaldoVisible =
                                                    !isSaldoVisible;
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              "assets/icon/View.svg",
                                              color: const Color(0xFF8D8D8D),
                                              width: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: const Color(0xFF43964F),
                                        ),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              "assets/icon/Down Arrow.svg",
                                              color: Colors.white,
                                              width: 24,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(nomorRekening),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: nomorRekening));
                                          _showFloatingPopup(context,
                                              "Nomor Rekening Disalin");
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icon/Copy.svg",
                                          color: const Color(0xFF8D8D8D),
                                          width: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row()
                                ],
                              ),
                            ),
                          ),
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
