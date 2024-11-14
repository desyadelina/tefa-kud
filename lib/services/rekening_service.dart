import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RekeningService {
  final String baseUrl = 'http://192.168.1.9:8000/api/v1/pengguna';

  // Fungsi untuk mendapatkan semua rekening pengguna dan menyimpan no_rek
  Future<Map<String, dynamic>?> getAllRekeningPengguna() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil slug dan token dari sesi
    String? slug = prefs.getString('slug');
    String? token = prefs.getString('token');

    // Pastikan slug dan token tersedia
    if (slug == null && token == null) {
      throw Exception("Slug dan Token tidak ditemukan. Silakan login kembali.");
    } else if (slug == null) {
      throw Exception("Slug tidak ditemukan. Silakan login kembali.");
    } else if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }

    // Request ke endpoint dengan autentikasi Bearer Token
    final response = await http.get(
      Uri.parse('$baseUrl/$slug/rekening-pengguna'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).isNotEmpty ? data['data'][0] : null;
    } else {
      throw Exception("Gagal mengambil data rekening: ${response.statusCode}");
    }
  }

  // Fungsi untuk mengambil detail rekening menggunakan no_rek dari SharedPreferences
  Future<Map<String, dynamic>?> getRekeningPengguna() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil no_rek yang sudah disimpan di SharedPreferences
    String? slug = prefs.getString('slug');
    String? noRek = prefs.getString('no_rek');
    String? token = prefs.getString('token');

    if (slug == null || noRek == null || token == null) {
      throw Exception(
          "Slug, No rekening, atau Token tidak ditemukan. Silakan login kembali.");
    }

    // Request ke endpoint dengan no_rek
    final response = await http.get(
      Uri.parse('$baseUrl/$slug/rekening-pengguna/$noRek'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // Cek status response
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Data Rekening tidak ditemukan.");
    } else {
      throw Exception("Gagal mengambil data rekening: ${response.statusCode}");
    }
  }
}
