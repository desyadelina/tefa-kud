import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tefa_kud/Settings/screens/profile_screen.dart';
import 'package:tefa_kud/Start/screens/home_page.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:tefa_kud/main/transfer_screen.dart';
import 'package:tefa_kud/widget/layout/detailed_layout.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
     TransferScreen(),
    const DetailedPage(
      content: ProfilePage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _widgetOptions.length, vsync: this);
  }

  void _onTabTapped(int index) {
    setState(() {});
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BottomBar(
        fit: StackFit.expand,
        // icon: (width, height) => Center(
        //   child: IconButton(
        //     padding: EdgeInsets.zero,
        //     onPressed: null,
        //     icon: Icon(
        //       Icons.arrow_upward_rounded,
        //       color: const Color(0xFFFFFFFF),
        //       size: width,
        //     ),
        //   ),
        // ),
        borderRadius: BorderRadius.circular(50),
        duration: const Duration(milliseconds: 750),
        curve: Curves.decelerate,
        showIcon: false,
        width: MediaQuery.of(context).size.width * 0.7,
        barColor: const Color(0xFF171717),
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 50,
        iconWidth: 50,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: _widgetOptions.map((widget) {
            return Navigator(
              key: navigatorKeys[_widgetOptions.indexOf(widget)],
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (context) => widget);
              },
            );
          }).toList(),
        ),
        child: TabBar(
          controller: _tabController,
          onTap: _onTabTapped,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator: const BoxDecoration(),
          tabs: const [
            Tab(
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: 20,
              ),
            ),
            Tab(
              icon: FaIcon(
                FontAwesomeIcons.scroll,
                size: 20,
              ),
            ),
            Tab(
              icon: FaIcon(
                FontAwesomeIcons.solidUser,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
