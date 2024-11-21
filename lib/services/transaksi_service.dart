import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionService {
  // final String baseUrl = 'http://192.168.100.86:8000/api';
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<dynamic>?> getTransactionHistory(
      String slug, String rekening) async {
    String? token = await storage.read(key: 'token');
    final url =
        Uri.parse('$baseUrl/v1/transaksi/$slug/$rekening/riwayat_transaksi');

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

  Future<List<dynamic>?> getRekeningPengguna(String slug, String rekening) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna/$rekening');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['data'] is List) {
        return data['data'];
      } else if (data['data'] is Map) {
        return [data['data']];
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      throw Exception('Gagal memuat pengguna: ${response.body}');
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
      throw Exception('Gagal memuat pengguna: ${response.body}');
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

  Future<Map<String, dynamic>?> konfirmasiRekening(
      String slug, String rekening, String pin) async {
    String? token = await storage.read(key: 'token');
    final url = Uri.parse(
        '$baseUrl/v1/pengguna/$slug/rekening-pengguna/$rekening/konfirmasi-rekening');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pin': pin,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengkonfirmasi PIN: ${response.body}');
    }
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
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rekening_tujuan': rekeningTujuan,
        'nominal_transaksi': nominalTransaksi,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengirim uang: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> topUp(
      String slug, String rekening, double nominal) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/v1/transaksi/$slug/$rekening/top_up'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nominal_transaksi': nominal}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal melakukan isi saldo: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> tarikUang(
      String slug, String rekening, double nominal) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/v1/transaksi/$slug/$rekening/tarik_uang'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nominal_transaksi': nominal}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal melakukan penarikan uang: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> pinjaman(
      String slug, String rekening, double nominal, int tenor) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/v1 / transaks i/$slug/$rekening/pinjaman'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nominal_transaksi': nominal,
        'tenor': tenor,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal melakukan permintaan pinjaman: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> pembayaran(
      String slug, String rekening, double nominal) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/v1/transaksi/$slug/$rekening/pembayaran'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nominal_transaksi': nominal}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal melakukan pembayaran: ${response.body}');
    }
  }
}
