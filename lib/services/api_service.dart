import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.1.9:8000/api';  // Ganti dengan URL API kamu

  // Fungsi untuk melakukan request API yang memerlukan autentikasi
  Future<Map<String, dynamic>?> fetchData(String endpoint, String token) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Menyertakan token di header
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('API request failed: ${response.statusCode}');
      return null;
    }
  }
}
