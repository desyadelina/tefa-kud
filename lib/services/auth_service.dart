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
      print('User  data: ${data['pengguna']}');
      print('User  slug: ${data['slug']}');
      return data;
    } else {
      print('Login error: ${response.body}');
      return jsonDecode(response.body);
    }
  }
}
