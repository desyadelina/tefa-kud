import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class rekeningCard extends StatelessWidget {
  final bool isLoading;
  final String formattedCurrency;
  final String nomorRekening;
  final bool isSaldoVisible;
  final Function() onVisibilityToggle;
  final Function(BuildContext, String) showFloatingPopup;

  const rekeningCard({
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
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: MediaQuery.of(context).size.width <= 412
            ? (MediaQuery.of(context).size.width / 412 * 18).clamp(8, 32)
            : 32,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 130,
          color: const Color(0xFFF9F9F9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                Container()
              else
                const Text(
                  'Saldo sekarang',
                  style: TextStyle(color: Color(0xFF8D8D8D)),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            fontFamily: 'RedRose',
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
              const SizedBox(height: 12),
              Row(
                children: [
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
                            Clipboard.setData(
                                ClipboardData(text: nomorRekening));
                            showFloatingPopup(
                                context, "Nomor Rekening Disalin");
                          },
                          child: SvgPicture.asset(
                            "assets/icon/Copy.svg",
                            color: const Color(0xFF8D8D8D),
                            width: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const Row()
            ],
          ),
        ),
      ),
    );
  }
}
