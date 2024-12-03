import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tefa_kud/config/api_config.dart';

class AuthService {
  final String baseUrl = ApiConfig.baseUrl;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Storage keys
  static const String KEY_TOKEN = 'token';
  static const String KEY_USER = 'user';
  static const String KEY_PIN = 'pin';
  static const String KEY_GUIDE_SHOWN = 'guide_shown';

  Future<Map<String, dynamic>?> login(String noTelepon, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signin'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'no_telepon': noTelepon, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await Future.wait([
          storage.write(key: KEY_TOKEN, value: data['token']),
          storage.write(key: KEY_USER, value: jsonEncode(data['pengguna'])),
          storage.write(key: KEY_PIN, value: data['pengguna']['pin']),
        ]);
        return data;
      }
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signOut() async {
    final token = await storage.read(key: KEY_TOKEN);
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/signout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode != 200) {
          throw Exception('Signout failed: ${response.body}');
        }
      } finally {
        await storage.deleteAll();
      }
    }
  }

  // Optimized login check
  Future<bool> isLoggedIn() async {
    final hasToken = await storage.read(key: KEY_TOKEN) != null;
    if (!hasToken) return false;
    return await validateToken();
  }

  // Improved user data retrieval
  Future<Map<String, dynamic>?> getStoredUser() async {
    try {
      final userData = await storage.read(key: KEY_USER);
      return userData != null ? jsonDecode(userData) : null;
    } catch (_) {
      return null;
    }
  }

  // Improved token validation
  Future<bool> validateToken() async {
    try {
      final token = await storage.read(key: KEY_TOKEN);
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/validate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Guide screen methods
  Future<bool> hasGuideBeenShown() async {
    return await storage.read(key: KEY_GUIDE_SHOWN) == 'true';
  }

  Future<void> markGuideAsShown() async {
    await storage.write(key: KEY_GUIDE_SHOWN, value: 'true');
  }
}
