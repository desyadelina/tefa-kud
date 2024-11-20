import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://192.168.33.169:8000/api';

  Future<Map<String, dynamic>?> login(String noTelepon, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'no_telepon': noTelepon,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveSession(data);
      return data;
    } else {
      print('Login failed: ${response.statusCode}');
      print(response.body);
      return null;
    }
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan token dan no_telepon
    await prefs.setString('token', data['token'] ?? '');
    await prefs.setString('no_telepon', data['no_telepon'] ?? '');

    // Simpan informasi pengguna jika tersedia
    if (data['pengguna'] != null) {
      await prefs.setInt('pengguna_id', data['pengguna']['id']);
      await prefs.setString('nama_pengguna', data['pengguna']['nama_pengguna']);
      await prefs.setString('username', data['pengguna']['username']);
      await prefs.setString('slug', data['pengguna']['slug']);
      await prefs.setString('jenis_kelamin', data['pengguna']['jenis_kelamin']);
      await prefs.setString('alamat', data['pengguna']['alamat']);
      await prefs.setString('foto_diri', data['pengguna']['foto_diri']);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('no_telepon');
  }

  Future<String?> getNoTelepon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('no_telepon');
  }
}
