import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/detail_bayar_pinjaman.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class ListBayarPinjaman extends StatefulWidget {
  final String title;

  const ListBayarPinjaman({super.key, required this.title});

  @override
  State<ListBayarPinjaman> createState() => _ListBayarPinjamanState();
}

class _ListBayarPinjamanState extends State<ListBayarPinjaman> {
  TransactionService transactionService = TransactionService();
  List<Map<String, dynamic>> _cicilanList = [];

  double totalTagihan = 0.0;
  double saldo = 0.0;
  String nomorRekening = '';
  String formattedSaldo = '';
  String formattedTotalTagihan = '';
  bool isSaldoVisible = true;
  String? noRekPengguna;
  String? userSlug;

  @override
  void initState() {
    super.initState();
    _getUserAccount();
    _fetchTotalPinjaman();
  }

  Future<void> _getUserAccount() async {
    userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData =
        await transactionService.getRekeningPengguna(userSlug!, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    noRekPengguna = rekeningData[0]['no_rek'] ?? '';

    try {
      var rekeningData = await transactionService.getRekeningPengguna(
          userSlug!, noRekPengguna!);
      if (rekeningData != null && rekeningData.isNotEmpty) {
        var rekening = rekeningData[0];
        setState(() {
          saldo = (rekening['saldo'] is int)
              ? (rekening['saldo'] as int).toDouble()
              : (rekening['saldo'] ?? 0.0);
          nomorRekening = rekening['no_rek'];
          formattedSaldo = NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(saldo);
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

  Future<void> _fetchTotalPinjaman() async {
    userSlug = await transactionService.getUserSlug();

    if (userSlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan sign in terlebih dahulu')),
      );
      return;
    }

    var rekeningData =
        await transactionService.getRekeningPengguna(userSlug!, '');
    if (rekeningData == null || rekeningData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening tidak ditemukan')),
      );
      return;
    }

    noRekPengguna = rekeningData[0]['no_rek'];

    try {
      final pinjamanData = await transactionService.getTotalPinjaman(
          userSlug!, noRekPengguna ?? '');
      final cicilanList = await _generateCicilanList(userSlug!, noRekPengguna!);
      setState(() {
        totalTagihan = pinjamanData['sisa_pinjaman'];
        formattedTotalTagihan = NumberFormat.currency(
          locale: 'id',
          symbol: 'Rp',
          decimalDigits: 0,
        ).format(totalTagihan);
        _cicilanList = cicilanList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat total pinjaman: ${e.toString()}')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _generateCicilanList(
      String slug, String rekening) async {
    final cicilanData =
        await transactionService.getCicilanList(slug, rekening ?? '');
    List<Map<String, dynamic>> list = [];
    for (var cicilan in cicilanData) {
      if (cicilan['status'] == 'Belum Lunas' ||
          cicilan['status'] == 'Diproses') {
        list.add({
          'id': cicilan['id'],
          'amount': cicilan['jumlah_cicilan'],
          'dueDate': DateFormat('dd MMMM yyyy').format(
            DateTime.parse(cicilan['tanggal_jatuh_tempo']),
          ),
          'status': cicilan['status'],
        });
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                totalTagihan > 0
                                    ? formattedTotalTagihan
                                    : 'Rp 0',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Transaksi Pinjaman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _cicilanList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _cicilanList.length,
                          itemBuilder: (context, index) {
                            final item = _cicilanList[index];
                            return _buildTransactionItem(
                              amount: NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(item['amount']),
                              date: item['dueDate'],
                              icon: FontAwesomeIcons.moneyBill,
                              status: item['status'],
                              onPressed: item['status'] == 'Belum Lunas'
                                  ? () {
                                      DateTime dueDate =
                                          DateFormat('dd MMMM yyyy')
                                              .parse(item['dueDate']);
                                      if (DateTime.now().isBefore(dueDate)) {
                                        if (userSlug != null &&
                                            noRekPengguna != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailBayarPinjaman(
                                                id: item['id'],
                                                amount: NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp',
                                                  decimalDigits: 0,
                                                ).format(item['amount']),
                                                dueDate: item['dueDate'],
                                                userSlug: userSlug!,
                                                noRekPengguna: noRekPengguna!,
                                                title: '',
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Data pengguna tidak lengkap')),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text(
                            'Anda tidak memiliki pinjaman yang harus dibayarkan'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String amount,
    required String date,
    IconData? icon,
    required String status,
    VoidCallback? onPressed, // Fungsi untuk navigasi
  }) {
    return GestureDetector(
      onTap: onPressed, // Panggil fungsi navigasi saat item diklik
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: status == 'Diproses' ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) // Menampilkan icon hanya jika diberikan
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FaIcon(
                      icon,
                      color: status == 'Diproses'
                          ? Colors.grey
                          : Colors.green, // Sesuaikan warna dengan desain
                      size: 24,
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            status == 'Diproses' ? Colors.grey : Colors.black,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 'Diproses' ? Colors.grey : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (status != 'Diproses')
              const Icon(
                Icons.chevron_right,
                color: Colors.green, // Warna ikon kanan
              ),
          ],
        ),
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
