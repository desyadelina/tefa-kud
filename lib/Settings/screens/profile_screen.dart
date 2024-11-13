// ignore_for_file: non_constant_identifier_names, unused_field, deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:tefa_kud/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/logo/koperasi-indonesia-seeklogo.png'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 150, 79),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _editProfile,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              button(
                onPressed: () {
                  NavigatorManager.navigatorKey.currentState
                      ?.pushNamed('/splashscreen');
                },
                text: "Splashscreen",
                backgroundColor: const Color(0xFF171717),
                textColor: Colors.white,
                outlineColor: const Color(0xFF171717),
              ),
              const SizedBox(height: 16.0),
              button(
                onPressed: () {
                  NavigatorManager.navigatorKey.currentState
                      ?.pushNamed('/profileEdit');
                },
                text: "Edit Profile",
                backgroundColor: const Color(0xFF171717),
                textColor: Colors.white,
                outlineColor: const Color(0xFF171717),
                icon: SvgPicture.asset(
                  'assets/icon/Dialing Number.svg',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              button(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPage(),
                    ),
                  );
                },
                text: "Ganti Pin",
                backgroundColor: const Color(0xFF171717),
                textColor: Colors.white,
                outlineColor: const Color(0xFF171717),
                icon: SvgPicture.asset(
                  'assets/icon/Dialing Number.svg',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              // Button 2
              button(
                onPressed: () {},
                text: "Keluar",
                backgroundColor: Colors.white,
                textColor: const Color(0xFFD02727),
                outlineColor: const Color(0xFFD02727),
                icon: SvgPicture.asset(
                  'assets/icon/Logout.svg',
                  width: 20,
                  height: 20,
                  color: const Color.fromARGB(255, 255, 0, 0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin berhasil diganti'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the new page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
