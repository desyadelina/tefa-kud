// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tefa_kud/widget/button.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginMain> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController(text: "+62");
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isObscured = true;
  String _selectedCountryCode = "+62";

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 64,
            left: 32,
            child: Image.asset(
              'assets/logo/koperasi-indonesia-seeklogo.png',
              width: 50,
              height: 50,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 160),
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 775),
                    child: SlideAnimation(
                      verticalOffset: 90.0,
                      child: FadeInAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 36),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MASUK',
                                  style: TextStyle(
                                      fontFamily: 'RedRose',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                const Text(
                                  'Masuk dan nikmati layanan koperasi yang ramah dan bersahabat.',
                                  style: TextStyle(
                                    fontFamily: 'RedRose',
                                    color: Color.fromARGB(255, 102, 102, 102),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _usernameFocusNode.hasFocus
                                              ? Colors.green
                                              : const Color.fromARGB(
                                                  255, 128, 127, 127),
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
                                          items: <String>[
                                            '+62',
                                            '+1',
                                            '+44',
                                            '+91',
                                            '+77',
                                            '+48',
                                          ] // TOLONG TAMBAHI NOMOR LAGI YAHHHH
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  fontFamily: 'RedRose',
                                                  color: Colors.grey,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }).toList(),
                                          underline:
                                              Container(), // Remove underline
                                          icon: const Icon(Icons
                                              .arrow_drop_down), // Dropdown icon
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
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "Nomor Telepon",
                                          labelStyle: TextStyle(
                                            fontFamily: 'RedRose',
                                            color: _usernameFocusNode.hasFocus
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _isObscured,
                                  focusNode: _passwordFocusNode,
                                  style: const TextStyle(
                                    fontFamily: 'RedRose',
                                    color: Colors.grey,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      fontFamily: 'RedRose',
                                      color: _passwordFocusNode.hasFocus
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: Checkbox(
                                            side: const BorderSide(
                                              color: Color(0xFF8D8D8D),
                                              width: 1.4,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            value: !_isObscured,
                                            activeColor: Colors.green,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _isObscured = !value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Tampilkan kata sandi",
                                          style: TextStyle(
                                            fontFamily: 'RedRose',
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                button(
                                  onPressed: () {
                                    String countryCode =
                                        _countryCodeController.text;
                                    String username = _usernameController.text;
                                    String password = _passwordController.text;
                                    print(
                                        "Country Code: $countryCode, Username: $username, Password: $password");
                                  },
                                  text: "Masuk",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
