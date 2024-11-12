import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferScreen extends StatelessWidget {
  final List<Map<String, String>> accountHistory = [
    {"nama": "Azizah A", "rek": "123 456 789"},
    {"nama": "Azizah B", "rek": "123 456 789"},
    {"nama": "Azizah C", "rek": "123 456 789"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF43964F), 
      body: Column(
        children: [
          Container(
            color: Color(0xFF43964F),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Text(
                    "Transfer",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.redRose(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2), 
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Button "transfer ke tujuan baru"
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                      },
                      icon: Icon(Icons.wallet_travel, color: Colors.white),
                      label: Text(
                        "Transfer ke tujuan baru",
                        style: GoogleFonts.redRose(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Riwayat rekening",
                          style: GoogleFonts.redRose(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                      
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                            },
                            icon: Icon(Icons.search, color: Colors.grey),
                            label: Text(
                              "Temukan rekening",
                              style: GoogleFonts.redRose(
                                color: Colors.grey,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF2F2F2),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: accountHistory.length,
                          itemBuilder: (context, index) {
                            final account = accountHistory[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.account_balance_wallet, color: Colors.white),
                                  ),
                                  title: Text(
                                    account['nama']!,
                                    style: GoogleFonts.redRose(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    account['rek']!,
                                    style: GoogleFonts.redRose(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey), 
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}