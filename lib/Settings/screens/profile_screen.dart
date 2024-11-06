// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'RedRose',
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 150, 79),
        toolbarHeight: 98,
      ),
      body: BottomBar(
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: const Color(0xFFFFFFFF),
              size: width,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        showIcon: false,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: const Color(0xFF171717),
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            ProfilePage(context),
            ProfilePage(context),
            ProfilePage(context),
          ],
        ),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator: const BoxDecoration(),
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.collections_bookmark_sharp)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

  Container ProfilePage(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
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
              Text(
                "Nomor Telepon",
                style: TextStyle(
                  fontFamily: 'RedRose',
                  color:
                      _usernameFocusNode.hasFocus ? Colors.green : Colors.grey,
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPage(), // Navigate to NewPage
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171717),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward,
                          color: Colors.white), // Icon for Button 1
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        "Ganti Pin",
                        style: TextStyle(
                          fontFamily: 'RedRose',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16, // Adjust font size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Button 2
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // Background color
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning,
                        color: Color.fromARGB(
                            255, 255, 0, 0)), // Icon for Button 2
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      "Keluar",
                      style: TextStyle(
                        fontFamily: 'RedRose',
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontSize: 16, // Adjust font size
                      ),
                    ),
                  ],
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
        title: const Text('New Page'),
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

class FillerPage extends StatelessWidget {
  final String message;

  const FillerPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
