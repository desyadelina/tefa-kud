// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/screens/transfer/transfer_new_rek.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tefa_kud/main.dart';

class ListTransfer extends StatefulWidget {
  const ListTransfer({super.key});

  @override
  State<ListTransfer> createState() => _ListTransferState();
}

class _ListTransferState extends State<ListTransfer> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allAccounts = [
    'Apel Muda',
    'Jeruk Segar',
    'Mangga Manis',
    'Anggur Merah',
    'Pepaya Segar',
  ];
  List<String> filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    filteredAccounts = allAccounts;
    _searchController.addListener(_filterAccounts);
  }

  void _filterAccounts() {
    setState(() {
      String searchTerm = _searchController.text.toLowerCase();
      filteredAccounts = allAccounts
          .where((account) => account.toLowerCase().contains(searchTerm))
          .toList();
    });
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_filterAccounts);
    _searchController.dispose();
    super.dispose();
  }

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
            ),
            onPressed: () {
              NavigatorManager.navigatorKey.currentState
                  ?.pushNamed('/TransferNewRek');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.userGroup,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Transfer ke Rek Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.all(16.0), // Menambahkan padding untuk tata letak
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Mengatur posisi teks ke kiri
              children: [
                Text(
                  'Riwayat Rekening',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10.0), // Memberikan jarak antar widget
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Temukan Rekening',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFF43964F)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFF43964F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF43964F), width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Expanded(
          //   child: HistoryTransferBuilder(accounts: filteredAccounts),
          // ),
        ],
      ),
    );
  }
}

class HistoryTransferBuilder extends StatelessWidget {
  final List<String> accounts;

  const HistoryTransferBuilder({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return accounts.isEmpty
        ? const Center(
            child: Text(
              'Tidak ada rekening ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: FaIcon(
                    FontAwesomeIcons.solidUser,
                    color: Colors.grey[700],
                  ),
                ),
                title: Text(accounts[index]),
                subtitle: const Text('1283 1234 1234'),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                onTap: () {
                  // Action saat item di klik
                },
              );
            },
          );
  }
}
