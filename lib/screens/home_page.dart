import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/list_bayar_pinjaman.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';
import 'package:intl/intl.dart';
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
  bool isSaldoVisible = false;
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

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        backgroundColor: const Color.fromARGB(223, 255, 255, 255),
        color: const Color(0xFF43964F),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF43964F),
              expandedHeight: 78.0,
              toolbarHeight: 70,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding:
                    const EdgeInsetsDirectional.only(start: 16, top: 30),
                title: Opacity(
                  opacity: _appBarOpacity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: MediaQuery.of(context).size.width <= 412
                          ? (MediaQuery.of(context).size.width / 412 * 16)
                              .clamp(8, 16)
                          : 18,
                    ),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width <= 412
                                            ? (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    412 *
                                                    18)
                                                .clamp(8, 32)
                                            : 32,
                                    vertical: 56),
                                child: Column(
                                  children: [
                                    if (_isLoading) ...[
                                      // Menu buttons skeleton
                                      SizedBox(
                                        height: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            4,
                                            (index) => Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Banner skeleton
                                      Container(
                                        height: 150,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      // Transactions skeleton
                                      Column(
                                        children: List.generate(
                                          5,
                                          (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      height: 16,
                                                      color: Colors.grey[300],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Container(
                                                      width: 80,
                                                      height: 14,
                                                      color: Colors.grey[300],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Container(
                                                  width: 100,
                                                  height: 16,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else
                                      Visibility(
                                        visible: !_isLoading,
                                        child: Column(
                                          children: [
                                            // Menu buttons
                                            SizedBox(
                                              height: 120,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: iconMenuButton(
                                                      'Transfer',
                                                      'assets/images/Transfer.png',
                                                      () {
                                                        NavigatorManager
                                                            .navigatorKey
                                                            .currentState
                                                            ?.pushNamed(
                                                                '/TransferNewRek');
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: iconMenuButton(
                                                      'Isi saldo',
                                                      'assets/images/Isi Saldo.png',
                                                      () {
                                                        NavigatorManager
                                                            .navigatorKey
                                                            .currentState
                                                            ?.pushNamed(
                                                                '/isiSaldo');
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: iconMenuButton(
                                                      'Tarik tunai',
                                                      'assets/images/Tarik Tunai.png',
                                                      () {
                                                        NavigatorManager
                                                            .navigatorKey
                                                            .currentState
                                                            ?.pushNamed(
                                                                '/tarikTunai');
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: iconMenuButton(
                                                      'Pinjaman',
                                                      'assets/images/Pinjaman.png',
                                                      () {
                                                        NavigatorManager
                                                            .navigatorKey
                                                            .currentState
                                                            ?.pushNamed(
                                                                '/pinjaman');
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text('Hari ini',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                const SizedBox(height: 16.0),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (_isLoading)
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                              color: Color(
                                                                  0xFF43964F),
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
                                                      Builder(
                                                        builder: (context) {
                                                          final todayTransactions =
                                                              riwayatTransaksi
                                                                  .where(
                                                                      (transaction) {
                                                            if (transaction ==
                                                                    null ||
                                                                transaction[
                                                                        'tanggal_transaksi'] ==
                                                                    null) {
                                                              return false;
                                                            }
                                                            try {
                                                              final createdAt =
                                                                  DateTime.parse(
                                                                      transaction[
                                                                          'tanggal_transaksi']);
                                                              return isToday(
                                                                  createdAt);
                                                            } catch (e) {
                                                              return false;
                                                            }
                                                          }).toList();

                                                          if (todayTransactions
                                                              .isEmpty) {
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          40),
                                                              width: double
                                                                  .infinity,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Tidak ada transaksi",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }

                                                          return Column(
                                                            children:
                                                                todayTransactions
                                                                    .map(
                                                                        (transaction) {
                                                              // Add null checks for transaction data
                                                              final String
                                                                  transactionType =
                                                                  transaction['jenis_transaksi']
                                                                          ?.toString() ??
                                                                      '';
                                                              final int
                                                                  nominal =
                                                                  transaction[
                                                                          'nominal_transaksi'] ??
                                                                      0;
                                                              final bool
                                                                  isDebit =
                                                                  transactionType == 'kirim_uang' ||
                                                                      transactionType ==
                                                                          'tarik_uang' ||
                                                                      transactionType ==
                                                                          'pembayaran';

                                                              return _buildTransactionItem(
                                                                namaPengguna ??
                                                                    '',
                                                                formatTransactionType(
                                                                    transactionType),
                                                                nominal,
                                                                isDebit,
                                                              );
                                                            }).toList(),
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 80,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
              Text(type,
                  style: TextStyle(color: Colors.grey, fontSize: fontSize)),
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
    'pembayaran': 'Bayar Pinjaman',
  };

  return transactionTypes[jenisTransaksi.toLowerCase()] ??
      toBeginningOfSentenceCase(jenisTransaksi.replaceAll('_', ' ')) ??
      jenisTransaksi;
}
