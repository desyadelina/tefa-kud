import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RekeningService {
  final String baseUrl = 'http://192.168.33.169:8000/api/v1/pengguna';

  // Fungsi untuk mendapatkan semua rekening pengguna dan menyimpan no_rek
  Future<List<Map<String, dynamic>>> getAllRekeningPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String? slug = prefs.getString('slug');
    String? token = prefs.getString('token');

    if (slug == null || token == null) {
      throw Exception(
          "Slug atau Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$slug/rekening-pengguna'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(); // Mengubah menjadi List<Map<String, dynamic>>
    } else {
      throw Exception("Gagal mengambil data rekening: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>?> getFirstRekeningPengguna() async {
    final allRekening = await getAllRekeningPengguna();
    return allRekening.isNotEmpty ? allRekening[0] : null;
  }

  Future<Map<String, dynamic>?> getSelectedOrFirstRekening() async {
    final prefs = await SharedPreferences.getInstance();

    // Coba ambil rekening pilihan yang tersimpan
    String? savedNoRek = prefs.getString('selected_no_rek');

    if (savedNoRek != null) {
      try {
        // Jika ada rekening pilihan, ambil detail rekening tersebut
        return await getRekeningPengguna();
      } catch (e) {
        print("Gagal mengambil rekening pilihan: $e");
        // Jika gagal mengambil rekening, fallback ke rekening pertama
      }
    }

    // Jika tidak ada rekening pilihan atau gagal mengambil data, ambil rekening pertama
    try {
      return await getFirstRekeningPengguna();
    } catch (e) {
      print("Gagal mengambil rekening pertama: $e");
      throw Exception("Tidak ada rekening yang tersedia.");
    }
  }

  // Fungsi untuk mengambil detail rekening menggunakan no_rek dari SharedPreferences
  Future<Map<String, dynamic>?> getRekeningPengguna() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil no_rek yang sudah disimpan di SharedPreferences
    String? slug = prefs.getString('slug');
    String? noRek = prefs.getString('selected_no_rek'); // no_rek terpilih
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

  Future<void> saveSelectedRekening(String noRek) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_no_rek', noRek);
  }

  Future<String?> getSelectedRekening() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_no_rek');
  }
}
