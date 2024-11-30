import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionService {
  // final String baseUrl = 'http://192.168.100.86:8000/api';
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<dynamic> _getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data: ${response.body}');
    }
  }

  Future<dynamic> _postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengirim data: ${response.body}');
    }
  }

  Future<List<dynamic>?> getTransactionHistory(
      String slug, String rekening) async {
    final data =
        await _getRequest('/v1/transaksi/$slug/$rekening/riwayat_transaksi');
    return data['data'];
  }

  Future<Map<String, dynamic>?> getSlugByRekening(String rekening) async {
    return await _getRequest('/rekening/$rekening/slug');
  }

  Future<Map<String, dynamic>?> getNamaPenggunaByIdRekening(int id_rekening) async {
    return await _getRequest('/transaksi/$id_rekening/namaPengguna');
  }

  Future<List<dynamic>?> getRekeningPengguna(
      String slug, String rekening) async {
    final data =
        await _getRequest('/v1/pengguna/$slug/rekening-pengguna/$rekening');
    if (data['data'] is List) {
      return data['data'];
    } else if (data['data'] is Map) {
      return [data['data']];
    } else {
      throw Exception('Unexpected response format: $data');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _getRequest('/user');
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
    return await _postRequest(
        '/v1/pengguna/$slug/rekening-pengguna/$rekening/konfirmasi-rekening',
        {'pin': pin});
  }

  Future<Map<String, dynamic>?> kirimUang(String slug, String rekening,
      String rekeningTujuan, double nominalTransaksi) async {
    return await _postRequest('/v1/transaksi/$slug/$rekening/kirim_uang', {
      'rekening_tujuan': rekeningTujuan,
      'nominal_transaksi': nominalTransaksi,
    });
  }

  Future<Map<String, dynamic>> topUp(
      String slug, String rekening, double nominal) async {
    return await _postRequest('/v1/transaksi/$slug/$rekening/top_up', {
      'nominal_transaksi': nominal,
    });
  }

  Future<Map<String, dynamic>> tarikUang(
      String slug, String rekening, double nominal) async {
    return await _postRequest('/v1/transaksi/$slug/$rekening/tarik_uang', {
      'nominal_transaksi': nominal,
    });
  }

  Future<Map<String, dynamic>> pinjaman(
      String slug, String rekening, double nominal, int tenor) async {
    return await _postRequest('/v1/transaksi/$slug/$rekening/pinjaman', {
      'nominal_transaksi': nominal,
      'tenor': tenor,
    });
  }

  Future<Map<String, dynamic>> pembayaran(
      String slug, String rekening, double nominal) async {
    return await _postRequest('/v1/transaksi/$slug/$rekening/pembayaran', {
      'nominal_transaksi': nominal,
    });
  }
}
