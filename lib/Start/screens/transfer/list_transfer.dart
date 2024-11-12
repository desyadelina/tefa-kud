// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/transfer/transfer_new_rek.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    'Anggur Merah',
    'Anggur Merah',
    'Anggur Merah',
    'Pepaya Segar'
  ];
  List<String> filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    // Awalnya, tampilkan semua akun
    filteredAccounts = allAccounts;
    // Pantau perubahan di pencarian
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
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("dummy appbar"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const TransferNewRek(
                        title: 'Transfer ke Rekening Baru',
                      ),
                      transitionDuration:
                          Duration.zero, // Disable forward transition animation
                      reverseTransitionDuration: Duration
                          .zero, // Disable backward transition animation
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
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
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Rekening',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Temukan Rekening',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF43964F)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF43964F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF43964F), width: 2.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: HistoryTransferBuilder(accounts: filteredAccounts),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTransferBuilder extends StatelessWidget {
  final List<String> accounts;

  const HistoryTransferBuilder({Key? key, required this.accounts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
          subtitle: Text('1283 1234 1234'),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          onTap: () {},
        );
      },
    );
  }
}
