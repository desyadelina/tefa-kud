// ignore_for_file: depend_on_referenced_packages, avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/main.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class PinjamanPage extends StatefulWidget {
  const PinjamanPage({super.key, required String title});

  @override
  State<PinjamanPage> createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage>
    with SingleTickerProviderStateMixin {
  double nominal = 0.0;
  String nomorRekening = '';
  String formattedCurrency = '';
  String tenor = '';
  bool isSaldoVisible = true;
  final TextEditingController _nominalController = TextEditingController();
  bool isButtonEnabled = false;
  String? noRekPengguna;

  String? _selectedMonth;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpened = false;
  late AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _getUserAccount();
    _nominalController.addListener(_onNominalChanged);
  }

  Future<void> _getUserAccount() async {
    TransactionService transactionService = TransactionService();

    String? userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData =
        await transactionService.getRekeningPengguna(userSlug, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    String noRekPengguna = rekeningData[0]['no_rek'];

    try {
      var rekeningData =
          await transactionService.getRekeningPengguna(userSlug, noRekPengguna);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          nominal = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble()
              : rekening['saldo'];
          nomorRekening = rekening['no_rek'];
          formattedCurrency = NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(nominal);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rekening tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data rekening: ${e.toString()}')),
      );
    }
  }

  void _onNominalChanged() {
    final text = _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isNotEmpty) {
      final formattedText = NumberFormat('#,###').format(int.parse(text));
      _nominalController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    setState(() {
      isButtonEnabled = text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _nominalController.removeListener(_onNominalChanged);
    _nominalController.dispose();
    super.dispose();
  }

  Widget _buildDropdownItem(String item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonth = item;
          _isDropdownOpened = false;
          _arrowController.reverse();
        });
        _removeOverlay();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedMonth == item ? Colors.green[50] : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Text(
          item,
          style: TextStyle(
            color: _selectedMonth == item ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width - 32,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, 50),
            child: Material(
              elevation: 4,
              child: Container(
                height: 200,
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(12, (index) {
                    final month = '${index + 1} Bulan';
                    return _buildDropdownItem(month);
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        _isDropdownOpened = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Cek apakah halaman ini masih menggunakan rute '/pinjaman'
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != '/pinjaman' && _overlayEntry != null) {
      _removeOverlay();
    }
  }

  Future<void> _proceedToConfirm() async {
    double nominalPinjaman = double.tryParse(
            _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0.0;
    TransactionService transactionService = TransactionService();

    String? userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData =
        await transactionService.getRekeningPengguna(userSlug, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    if (nominalPinjaman > 0) {
      NavigatorManager.navigatorKey.currentState?.pushNamed(
        '/InputPinPinjaman',
        arguments: {
          'title': 'Konfirmasi Pinjaman',
          'nominalPinjaman': nominalPinjaman,
          'noRekPengguna': nomorRekening,
          'userSlug': userSlug,
          'tenor': _selectedMonth,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal tidak valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.money, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              'Tenor',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (_isDropdownOpened) {
                                    _arrowController.reverse();
                                    _removeOverlay();
                                  } else {
                                    _arrowController.forward();
                                    _showOverlay();
                                  }
                                  setState(() {
                                    _isDropdownOpened = !_isDropdownOpened;
                                  });
                                },
                                child: CompositedTransformTarget(
                                  link: _layerLink,
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedMonth ?? "Pilih bulan",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedMonth != null
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        AnimatedBuilder(
                                          animation: _arrowController,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle:
                                                  _arrowController.value * 3.14,
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: _isDropdownOpened
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
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
                  const SizedBox(height: 30),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.money, color: Color(0xFF43964F)),
                            SizedBox(width: 10),
                            Text(
                              'Nominal Pinjaman',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF43964F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Rp',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _nominalController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled ? _proceedToConfirm : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            isButtonEnabled ? Colors.black : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Lanjut',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
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
                    const Text(
                      'Saldo Sekarang',
                      style: TextStyle(color: Color(0xFF8D8D8D)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              isSaldoVisible
                                  ? formattedCurrency
                                  : 'Rp ${'*' * (formattedCurrency.length - 3)}',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSaldoVisible = !isSaldoVisible;
                                });
                              },
                              child: Icon(
                                isSaldoVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF8D8D8D),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFF43964F),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(nomorRekening),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: nomorRekening));
                            _showFloatingPopup(
                                context, "Nomor Rekening Disalin");
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
            ),
          ),
        ],
      ),
    );
  }

  void _showFloatingPopup(BuildContext context, String message) {
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
    Future.delayed(const Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }
}
