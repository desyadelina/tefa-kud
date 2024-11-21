import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // final String baseUrl = 'http://192.168.100.86:8000/api';
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String noTelepon, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'no_telepon': noTelepon,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      await storage.write(key: 'user', value: jsonEncode(data['pengguna']));
      await storage.write(key: 'pin', value: data['pengguna']['pin']);
      print('User  data: ${data['pengguna']}');
      return data;
    } else {
      print('Login error: ${response.body}');
      return jsonDecode(response.body);
    }
  }

  Future<void> signOut() async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sign out: ${response.body}');
    }

    await storage.delete(key: 'token');
    await storage.delete(key: 'pin');
  }
}
