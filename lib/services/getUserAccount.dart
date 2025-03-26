import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tefa_kud/services/transaksi_service.dart';

class UserAccountService {
  final TransactionService transactionService = TransactionService();

  Future<Map<String, dynamic>> getUserAccount(BuildContext context) async {
    Map<String, dynamic> result = {
      'saldo': 0.0,
      'nomorRekening': '',
      'namaPengguna': '',
      'riwayatTransaksi': [],
      'formattedCurrency': '',
    };

    try {
      String? userSlug = await transactionService.getUserSlug();

      if (userSlug == null) {
        throw Exception('Silahkan sign in terlebih dahulu');
      }

      var rekeningData =
          await transactionService.getRekeningPengguna(userSlug, '');
      if (rekeningData == null || rekeningData.isEmpty) {
        throw Exception('Rekening tidak ditemukan');
      }

      String noRekPengguna = rekeningData[0]['no_rek'];
      final rekeningDetail =
          await transactionService.getRekeningPengguna(userSlug, noRekPengguna);
      final riwayatTransaksiData = await transactionService
          .getTransactionHistory(userSlug, noRekPengguna);

      if (rekeningDetail != null && rekeningDetail.isNotEmpty) {
        final rekening = rekeningDetail[0];

        result['saldo'] = (rekening['saldo'] is int)
            ? (rekening['saldo'] as int).toDouble()
            : rekening['saldo'];
        result['nomorRekening'] = rekening['no_rek'];
        result['formattedCurrency'] = NumberFormat.currency(
          locale: 'id',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(result['saldo']);

        if (riwayatTransaksiData != null && riwayatTransaksiData.isNotEmpty) {
          final pengguna = await transactionService
              .getNamaPenggunaByIdRekening(rekening['id']);
          result['namaPengguna'] = pengguna?['pengguna'];

          result['riwayatTransaksi'] = riwayatTransaksiData
              .where((transaction) =>
                  transaction['status_transaksi'].toString().toLowerCase() !=
                  'pending')
              .take(5)
              .toList();
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    return result;
  }
}
