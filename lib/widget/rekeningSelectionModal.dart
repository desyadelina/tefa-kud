import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RekeningSelectionModal extends StatelessWidget {
  final List<Map<String, dynamic>> rekeningList;
  final Function(String) onRekeningSelected;

  const RekeningSelectionModal({
    Key? key,
    required this.rekeningList,
    required this.onRekeningSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pilih Rekening"),
      content: SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: rekeningList.length,
          itemBuilder: (context, index) {
            final rekening = rekeningList[index];
            String formattedCurrency = NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(rekening['saldo']);

            return GestureDetector(
              onTap: () {
                onRekeningSelected(rekening['no_rek']);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedCurrency,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rekening['no_rek'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
