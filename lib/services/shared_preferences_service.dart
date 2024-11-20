// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesService {
//   // Fungsi untuk menyimpan token
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   // Fungsi untuk mengambil token
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Fungsi untuk menghapus token
//   Future<void> removeToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//   }
// }
