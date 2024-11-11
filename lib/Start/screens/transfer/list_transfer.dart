// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/transfer/transfer_new_rek.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTransfer extends StatefulWidget {
  const ListTransfer({super.key});

  @override
  State<ListTransfer> createState() => _ListTransferState();
}

class _ListTransferState extends State<ListTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      MaterialPageRoute(
                        builder: (context) => const TransferNewRek(
                            title: 'Transfer ke Rekening Baru'),
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
            ],
          ),
        ),
      ),
    );
  }
}
