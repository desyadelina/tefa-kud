import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionService {
  // final String baseUrl = 'http://192.168.100.86:8000/api';
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<dynamic>?> getTransactionHistory(String slug) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/v1/transaksi/$slug/riwayat_transaksi');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load transaction history: ${response.body}');
    }
  }

  Future<List<dynamic>?> getRekeningPengguna(String slug) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load user account: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/user');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load current user: ${response.body}');
    }
  }

  Future<String?> getUserSlug() async {
    String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      var userData = jsonDecode(userJson);
      return userData['slug'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> kirimUang(String slug, String rekening,
      String rekeningTujuan, double nominalTransaksi) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/v1/transaksi/$slug/$rekening/kirim_uang');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'jenis_transaksi': 'kirim_uang',
        'rekening_tujuan': rekeningTujuan,
        'nominal_transaksi': nominalTransaksi,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send money: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> topUp(
      String slug, double nominalTransaksi) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/v1/transaksi/$slug/top_up');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'jenis_transaksi': 'top_up',
        'nominal_transaksi': nominalTransaksi,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to top up: ${response.body}');
    }
  }
}
