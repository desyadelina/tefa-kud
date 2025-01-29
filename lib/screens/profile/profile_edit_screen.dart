// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 224,
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFFF2F2F2),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(
                        'assets/logo/koperasi-indonesia-seeklogo.png'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Key : Nama Pengguna",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Nomor Telepon",
                    style: TextStyle(
                      fontFamily: 'RedRose',
                      color: _usernameFocusNode.hasFocus
                          ? Colors.green
                          : Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _usernameFocusNode.hasFocus
                                ? Colors.green
                                : const Color.fromARGB(255, 128, 127, 127),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCountryCode = newValue!;
                              });
                            },
                            items: <String>['+62']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontFamily: 'RedRose',
                                    color: Colors.grey,
                                    fontSize: 18, // Reduced font size
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          style: const TextStyle(
                            fontFamily: 'RedRose',
                            color: Colors.grey,
                            fontSize: 16, // Reduced font size
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kata Sandi",
                        style: TextStyle(
                          fontFamily: 'RedRose',
                          color: _passwordFocusNode.hasFocus
                              ? Colors.green
                              : Colors.grey,
                          fontSize: 16, // Reduced font size
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText:
                            _isObscured, // Control visibility with this variable
                        focusNode: _passwordFocusNode,
                        style: const TextStyle(
                          fontFamily: 'RedRose',
                          color: Colors.grey,
                          fontSize: 16, // Reduced font size
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons
                                      .visibility_off, // Change icon based on state
                              color: const Color.fromARGB(255, 67, 150, 79),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured =
                                    !_isObscured; // Toggle the boolean value
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
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
        ),
      ),
    );
  }
}
