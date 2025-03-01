import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class saldoCard extends StatelessWidget {
  final bool isLoading;
  final String formattedCurrency;
  final String nomorRekening;
  final bool isSaldoVisible;
  final Function() onVisibilityToggle;
  final Function(BuildContext, String) showFloatingPopup;

  const saldoCard({
    Key? key,
    required this.isLoading,
    required this.formattedCurrency,
    required this.nomorRekening,
    required this.isSaldoVisible,
    required this.onVisibilityToggle,
    required this.showFloatingPopup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              Container()
            else
              const Text(
                'Saldo Sekarang',
                style: TextStyle(color: Color(0xFF8D8D8D)),
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isLoading)
                      Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    else
                      Text(
                        isSaldoVisible ? formattedCurrency : 'Rp •••',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(width: 6),
                    if (!isLoading)
                      GestureDetector(
                        onTap: onVisibilityToggle,
                        child: Icon(
                          isSaldoVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF8D8D8D),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (isLoading)
              Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            else
              Row(
                children: [
                  Text(nomorRekening),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: nomorRekening));
                      showFloatingPopup(context, "Nomor Rekening Disalin");
                    },
                    child: Icon(
                      Icons.copy,
                      color: const Color(0xFF8D8D8D),
                      size: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
