import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
import 'package:tefa_kud/providers/bottom_bar_visibility_provider.dart';
import 'package:tefa_kud/widget/layout/auth_layout.dart';
import '../intro/login_page.dart';
import 'package:tefa_kud/services/getUserAccount.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final authService = AuthService();
  final transactionService = TransactionService();

  late Future<String?> _userSlugFuture;

  int currentPage = 0;
  final UserAccountService _userAccountService = UserAccountService();

  String nomorRekening = '';
  String namaPengguna = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _userSlugFuture = transactionService.getUserSlug();
    _getUserAccount();
  }

  Future<void> _getUserAccount() async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      final result = await _userAccountService.getUserAccount(context);

      if (mounted) {
        setState(() {
          nomorRekening = result['nomorRekening'];
          namaPengguna = result['namaPengguna'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _logout() async {
    final AuthService authService = AuthService();
    await authService.signOut(context);

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
          borderRadius: BorderRadius.circular(16),
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
              if (_isLoading)
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                )
              else
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/logo/koperasi-indonesia-seeklogo.png'),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      Container(
                        width: 150,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    else
                      Text(
                        namaPengguna,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fsName,
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            nomorRekening,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    else
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF43964F), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(180, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          "Edit Akun",
                          style: TextStyle(
                            color: Color(0xFF43964F),
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                // Skeleton for Ganti Pin
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              else
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
              if (_isLoading)
                Container()
              else
                const Divider(
                  color: Color(0xFFd9d9d9),
                  thickness: 1,
                  height: 1,
                ),
              if (_isLoading)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              else
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
              if (_isLoading)
                Container()
              else
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
              if (_isLoading)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              else
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
