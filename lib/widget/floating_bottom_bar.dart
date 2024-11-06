// import 'package:flutter/material.dart';
// import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

// class FloatingBottomBar extends StatelessWidget {
//   final PageController _AppPageController = PageController();

//   @override
//   void dispose() {
//     _AppPageController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomBar(
//       child: TabBar(
//         controller: _AppPageController,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey,
//         indicator: BoxDecoration(),
//         tabs: [
//           Tab(icon: Icon(Icons.home)),
//           Tab(icon: Icon(Icons.favorite_border)),
//           Tab(icon: Icon(Icons.person)),
//         ],
//       ),
//       fit: StackFit.expand,
//       icon: (width, height) => Center(
//         child: IconButton(
//           padding: EdgeInsets.zero,
//           onPressed: null,
//           icon: Icon(
//             Icons.arrow_upward_rounded,
//             color: Color(0xFFFFFFFF),
//             size: width,
//           ),
//         ),
//       ),
//       borderRadius: BorderRadius.circular(500),
//       duration: Duration(seconds: 1),
//       curve: Curves.decelerate,
//       showIcon: false,
//       width: MediaQuery.of(context).size.width * 0.8,
//       barColor: Color.fromARGB(255, 23, 23, 23),
//       start: 2,
//       end: 0,
//       offset: 10,
//       barAlignment: Alignment.bottomCenter,
//       iconHeight: 35,
//       iconWidth: 35,
//       reverse: false,
//       hideOnScroll: true,
//       scrollOpposite: false,
//       onBottomBarHidden: () {},
//       onBottomBarShown: () {},
//       body: (context, controller) => TabBarView(
//         controller: tabController,
//         physics: const BouncingScrollPhysics(),
//         children: [
//           InfiniteListPage(message: "INI HOME YAH!"),
//           InfiniteListPage(message: "INI GW GAK TAU"),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 30),
//                 Row(
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: _usernameFocusNode.hasFocus
//                               ? Colors.green
//                               : const Color.fromARGB(255, 128, 127, 127),
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: DropdownButton<String>(
//                           value: _selectedCountryCode,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               _selectedCountryCode = newValue!;
//                             });
//                           },
//                           items: <String>['+62', '+1', '+44', '+91']
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(
//                                 value,
//                                 style: TextStyle(
//                                   fontFamily: 'RedRose',
//                                   color: Colors.grey,
//                                   fontSize: 20,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             );
//                           }).toList(),
//                           underline: Container(),
//                           icon: Icon(Icons.arrow_drop_down),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _usernameController,
//                         focusNode: _usernameFocusNode,
//                         style: TextStyle(
//                           fontFamily: 'RedRose',
//                           color: Colors.grey,
//                         ),
//                         decoration: InputDecoration(
//                           labelText: "Nomor Telepon",
//                           labelStyle: TextStyle(
//                             fontFamily: 'RedRose',
//                             color: _usernameFocusNode.hasFocus
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.green),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: _isObscured,
//                   focusNode: _passwordFocusNode,
//                   style: TextStyle(
//                     fontFamily: 'RedRose',
//                     color: Colors.grey,
//                   ),
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     labelStyle: TextStyle(
//                       fontFamily: 'RedRose',
//                       color: _passwordFocusNode.hasFocus
//                           ? Colors.green
//                           : Colors.grey,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 16.0),
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: !_isObscured,
//                           activeColor: Colors.green,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _isObscured = !value!;
//                             });
//                           },
//                         ),
//                         Text(
//                           "Tampilkan kata sandi",
//                           style: TextStyle(
//                             fontFamily: 'RedRose',
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
