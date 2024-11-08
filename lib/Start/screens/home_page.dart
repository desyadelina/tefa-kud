// TODO Implement this library.// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/IconMenuButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _appBarOpacity = 1.0;
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
              expandedHeight: 90.0,
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
                  child: const Row(
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
                                horizontal: 20, vertical: 0),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                          ],
                                        ),
                                      ),
                                    ),
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
                                          ],
                                        ),
                                      ),
                                    ),
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
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
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 130,
                              color: Color(0xFFF9F9F9),
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
