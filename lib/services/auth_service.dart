import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tefa_kud/config/api_config.dart';
import 'package:tefa_kud/providers/bottom_bar_visibility_provider.dart';

class AuthService {
  final String baseUrl = ApiConfig.baseUrl;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Storage keys
  static const String KEY_TOKEN = 'token';
  static const String KEY_USER = 'user';
  static const String KEY_PIN = 'pin';
  static const String KEY_GUIDE_SHOWN = 'guide_shown';

  Future<Map<String, dynamic>?> login(String noTelepon, String password, BuildContext context) async {
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
        Provider.of<BottomBarVisibilityProvider>(context, listen: false).reset();
        return data;
      }
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signOut(BuildContext context) async {
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
    Provider.of<BottomBarVisibilityProvider>(context, listen: false).hide();
  }

  // Optimized login check
  Future<bool> isLoggedIn() async {
    final hasToken = await storage.read(key: KEY_TOKEN) != null;
    return hasToken;
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

  Future<bool> konfirmasiPengguna(String userSlug, String pin) async {
    final token = await storage.read(key: KEY_TOKEN);

    final response = await http.post(
      Uri.parse('$baseUrl/v1/pengguna/$userSlug/konfirmasi-pengguna'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'pin': pin}),
    );

    final responseBody = jsonDecode(response.body);
    return responseBody != null &&
        responseBody['message'] == 'Pengguna berhasil dikonfirmasi';
  }

  Future<bool> updatePin(String userSlug, String newPin) async {
    if (userSlug.isEmpty) {
      print('Error: userSlug is empty');
      return false;
    }

    final token = await storage.read(key: KEY_TOKEN);

    final response = await http.put(
      Uri.parse('$baseUrl/v1/pengguna/$userSlug/update-keamanan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'pin': newPin}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      await storage.write(key: KEY_PIN, value: newPin);
      return true;
    } else {
      return false;
    }
  }
}
