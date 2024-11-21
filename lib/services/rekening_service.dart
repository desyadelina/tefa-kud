import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tefa_kud/services/storage_service.dart';

class RekeningService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService storageService = StorageService();

  Future<String?> _getSlug() async {
    return await storageService.getString('slug');
  }

  Future<String?> _getToken() async {
    return await storageService.getString('token');
  }

  Future<List<Map<String, dynamic>>> getAllRekeningPengguna() async {
    String? slug = await _getSlug();
    String? token = await _getToken();

    if (slug == null || token == null) {
      throw Exception("Slug atau token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception("Gagal mengambil data rekening: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>?> getFirstRekeningPengguna() async {
    final allRekening = await getAllRekeningPengguna();
    return allRekening.isNotEmpty ? allRekening[0] : null;
  }

  Future<Map<String, dynamic>?> getSelectedOrFirstRekening() async {
    String? savedNoRek = await storageService.getString('selected_no_rek');

    if (savedNoRek != null) {
      try {
        return await getRekeningPengguna(savedNoRek);
      } catch (e) {
        print("Gagal mengambil rekening pilihan: $e");
      }
    }

    try {
      return await getFirstRekeningPengguna();
    } catch (e) {
      print("Gagal mengambil rekening pertama: $e");
      throw Exception("Tidak ada rekening yang tersedia.");
    }
  }

  Future<Map<String, dynamic>?> getRekeningPengguna(String noRek) async {
    String? slug = await _getSlug();
    String? token = await _getToken();

    if (slug == null || token == null) {
      throw Exception("Slug atau Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna/$noRek'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Data Rekening tidak ditemukan.");
    } else {
      throw Exception("Gagal mengambil data rekening: ${response.statusCode}");
    }
  }

  Future<void> saveSelectedRekening(String noRek) async {
    await storageService.saveString('selected_no_rek', noRek);
  }

  Future<void> konfirmasiRekening(String noRek, String password, String pin) async {
    String? slug = await _getSlug();
    String? token = await _getToken();

    if (slug == null || token == null) {
      throw Exception("Slug atau Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna/$noRek/konfirmasi-rekening'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'password': password,
        'pin': pin,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengkonfirmasi rekening: ${response.body}");
    }
  }

  Future<void> updateKeamanan(String noRek, {String? password, String? pin}) async {
    String? slug = await _getSlug();
    String? token = await _getToken();

    if (slug == null || token == null) {
      throw Exception("Slug atau Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/v1/pengguna/$slug/rekening-pengguna/$noRek/update-keamanan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        if (password != null) 'password': password,
        if (pin != null) 'pin': pin,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal memperbarui keamanan: ${response.body}");
    }
  }
}
