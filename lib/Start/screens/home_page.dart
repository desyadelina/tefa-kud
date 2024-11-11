// TODO Implement this library.// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double saldo = 17500000;
  final String nomorRekening = '1283 1234 1234';
  String formattedCurrency = '';
  bool isSaldoVisible = true;
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Format saldo ke dalam format rupiah setelah inisialisasi
    formattedCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(saldo);

    nomorRekening;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF43964F),
      //   toolbarHeight: 110,
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Padding(padding: EdgeInsets.only(left: 15)),
      //       CircleAvatar(
      //         radius: 24,
      //         backgroundImage:
      //             AssetImage('assets/logo/koperasi-indonesia-seeklogo.png'),
      //       ),
      //       SizedBox(width: 12),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             "Koperasi Unit Desa",
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white,
      //             ),
      //           ),
      //           Text(
      //             "Banjarbaru, Indonesia",
      //             style: TextStyle(
      //               fontSize: 14,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      iconMenuButton('Transfer',
                                          'assets/images/Transfer.png'),
                                      iconMenuButton('Isi saldo',
                                          'assets/images/Isi Saldo.png'),
                                      iconMenuButton('Tarik tunai',
                                          'assets/images/Tarik Tunai.png'),
                                      iconMenuButton('Pinjaman',
                                          'assets/images/Pinjaman.png'),
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
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
                                                : 'Rp ${'*' * formattedCurrency.replaceAll(RegExp(r'[^0-9]'), '').length}',
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
