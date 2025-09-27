import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:tefa_kud/Start/screens/mutasi/mutasi_page.dart';
import 'package:tefa_kud/screens/home_page.dart';
import 'package:tefa_kud/screens/profile/profile_page.dart';
import 'package:tefa_kud/widget/layout/detailed_layout.dart';
import 'package:tefa_kud/widget/layout/auth_layout.dart';
import 'package:tefa_kud/screens/intro/login_page.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/providers/bottom_bar_visibility_provider.dart';

class MainLayout extends StatefulWidget {
  final bool showWelcomeSnackbar;
  const MainLayout(
      {super.key, required String title, this.showWelcomeSnackbar = false});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    MutasiPage(
      titleBar: 'Mutasi',
      background: Colors.black,
    ),
    DetailedPage(
      backButtonStatus: false,
      titleBar: 'Akun Saya',
      content: ProfilePage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _widgetOptions.length, vsync: this);

    if (widget.showWelcomeSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selamat datang! Senang bertemu dengan Anda.'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
        _tabController.animateTo(_selectedIndex);
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarVisibilityProvider>(
      builder: (context, bottomBarVisibilityProvider, child) {
        return FutureBuilder<bool>(
          future: AuthService().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.data == true) {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: BottomBar(
                    fit: StackFit.expand,
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
                    body: (context, controller) => IndexedStack(
                      index: _selectedIndex,
                      children: _widgetOptions.map((widget) {
                        return Navigator(
                          onGenerateRoute: (routeSettings) {
                            return MaterialPageRoute(
                                builder: (context) => widget);
                          },
                        );
                      }).toList(),
                    ),
                    child: bottomBarVisibilityProvider.isVisible
                        ? TabBar(
                            controller: _tabController,
                            onTap: _onTabTapped,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicator: const BoxDecoration(),
                            tabs: const [
                              Tab(
                                  icon:
                                      FaIcon(FontAwesomeIcons.house, size: 20)),
                              Tab(
                                  icon: FaIcon(FontAwesomeIcons.scroll,
                                      size: 20)),
                              Tab(
                                  icon: FaIcon(FontAwesomeIcons.solidUser,
                                      size: 20)),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              );
            } else {
              return const AuthLayout(content: LoginScreen());
            }
          },
        );
      },
    );
  }
}
