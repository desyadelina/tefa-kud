// ignore_for_file: non_constant_identifier_names, unused_field, deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/list_bayar_pinjaman.dart';
import 'package:tefa_kud/screens/profile/ganti_pin/prev_pin_screen.dart';
import 'package:tefa_kud/screens/profile/profile_edit_screen.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/services/transaksi_service.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:tefa_kud/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widget/layout/auth_layout.dart';
import '../intro/login_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final authService = AuthService();
  final transactionService = TransactionService();

  late Future<Map<String, String>> _userDataFuture;
  late Future<String?> _userSlugFuture;

  late TabController tabController;
  final List<Color> colors = [Colors.blue, Colors.red, Colors.green];
  int currentPage = 0;

  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Dropdown selection
  String _selectedCountryCode = '+62';
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: colors.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentPage = tabController.index;
      });
    });

    _userDataFuture = _getUserData();
    _userSlugFuture = transactionService.getUserSlug();
  }

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data yang disimpan di SharedPreferences
    String namaPengguna =
        prefs.getString('nama_pengguna') ?? 'Nama tidak ditemukan';
    String alamat = prefs.getString('alamat') ?? 'Alamat tidak ditemukan';

    return {
      'nama_pengguna': namaPengguna,
      'alamat': alamat,
    };
  }

  @override
  void dispose() {
    tabController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _editProfile() {
    print('Edit profile pressed');
  }

  Future<void> _logout() async {
    await authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Border radius modern
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.exit_to_app_rounded, // Ikon logout
                size: 50,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Keluar Akun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Apakah Anda yakin ingin keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth >= 412
        ? 16
        : (14 - ((412 - screenWidth) / 2)).clamp(12, 16);
    double fsName = screenWidth >= 412
        ? 20
        : (14 - ((412 - screenWidth) / 2)).clamp(16, 20);
    return Container(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width <= 412
              ? (MediaQuery.of(context).size.width / 412 * 18).clamp(8, 32)
              : 32,
          32,
          MediaQuery.of(context).size.width <= 412
              ? (MediaQuery.of(context).size.width / 412 * 18).clamp(8, 32)
              : 32,
          86),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage:
                    AssetImage('assets/logo/koperasi-indonesia-seeklogo.png'),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                child: FutureBuilder<Map<String, String>>(
                    future: _userDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        // Ambil data dari snapshot
                        final userData = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['nama_pengguna']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fsName),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image:
                                      AssetImage('assets/images/Location.png'),
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${userData['alamat']}',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF43964F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(
                                    180, 40), // Set width to double.infinity
                              ),
                              child: Text(
                                "Edit Akun",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Pengguna: Tidak ada data',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/Location-gray.png'),
                                  height: 22,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Alamat: Tidak ada data',
                                  style: TextStyle(
                                      fontSize: fontSize, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TarikTunaiPage(
                                      title: '',
                                    ),
                                  ),
                                );
                              },
                              child: Text("Edit Akun"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF43964F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(220, 50),
                              ),
                              child: Text(
                                "Edit Akun",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              )
            ],
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: _userSlugFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final userSlug = snapshot.data ?? '';
                    return ListButtonMenuProfile(
                      text: "Ganti Pin",
                      iconPath: 'assets/icon/Dialing Number.svg',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviousPinPage(
                              title: 'Previous Pin',
                              userSlug: userSlug,
                              noRekPengguna: '',
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('User slug not found'));
                  }
                },
              ),
              const SizedBox(height: 8),
              const Divider(
                color: Color(0xFFd9d9d9),
                thickness: 1,
                height: 1,
              ),
              ListButtonMenuProfile(
                text: "Bayar Pinjaman",
                iconPath: 'assets/icon/Pay.svg',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListBayarPinjaman(
                        title: 'Bayar Pinjaman',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Divider(
                color: Color(0xFFd9d9d9),
                thickness: 1,
                height: 1,
              ),
            ],
          ),
          SizedBox(
            height: screenWidth >= 412
                ? 350
                : (screenWidth / 412 * 290).clamp(150, 390),
          ),
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width, 60),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Keluar Akun",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListButtonMenuProfile extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const ListButtonMenuProfile({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth >= 412
        ? 14
        : (14 - ((412 - screenWidth) / 2)).clamp(10, 14);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 30,
            height: 30,
            color: Color(0xFF43964F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF616161),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF616161),
            size: 18,
          ),
        ],
      ),
    );
  }
}
