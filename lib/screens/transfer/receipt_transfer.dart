// ignore_for_file: use_super_parameters, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tefa_kud/screens/home_page.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';
import 'package:intl/intl.dart';

class ReceiptTransfer extends StatefulWidget {
  final String title;
  final String nominal;
  final String date;
  final String namaPenerima;
  final String rekeningTujuan;

  const ReceiptTransfer({
    Key? key,
    required this.nominal,
    required this.date,
    required this.namaPenerima,
    required this.rekeningTujuan,
    required this.title,
  }) : super(key: key);

  @override
  State<ReceiptTransfer> createState() => _ReceiptTransferState();
}

class _ReceiptTransferState extends State<ReceiptTransfer> {
  final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color(0xFF43964F),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/bg-receipt.png'), // Background image
                fit: BoxFit.cover, // Cover the entire container
              ),
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF43AA4F),
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Transfer berhasil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Transfer saldo dana',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currencyFormat.format(double.parse(widget.nominal)),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Penerima dana',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF43964F),
                      radius: 20,
                      child: const FaIcon(
                        FontAwesomeIcons.solidUser,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namaPenerima,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.rekeningTujuan,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainLayout(
                          title: 'Selesai',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Selesai',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
