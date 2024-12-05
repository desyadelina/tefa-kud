import 'package:flutter/material.dart';
import 'package:tefa_kud/screens/intro/login_page.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:tefa_kud/widget/layout/auth_layout.dart';
import 'package:tefa_kud/widget/layout/guide_layout.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tefa_kud/widget/layout/start_guide_layout.dart';

class GuideMain extends StatefulWidget {
  const GuideMain({super.key});

  @override
  State<GuideMain> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideMain>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _appbarController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final PageController _startPageController = PageController();
  final PageController _guidePageController = PageController();
  String nextButtonText = "Selanjutnya";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2250),
      vsync: this,
    );

    _appbarController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -5), end: Offset.zero).animate(
      CurvedAnimation(parent: _appbarController, curve: Curves.easeInOutCirc),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.forward();
        _appbarController.forward();
      });
    });
  }

  void _updateNextButtonText() {
    setState(() {
      nextButtonText =
          (_guidePageController.page?.round() == 2) ? "Masuk!" : "Selanjutnya";
    });
  }

  @override
  void dispose() {
    _startPageController.dispose();
    _guidePageController.removeListener(_updateNextButtonText);
    _guidePageController.dispose();
    _controller.dispose();
    _appbarController.dispose();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/koperasi-indonesia-seeklogo.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  width: 14,
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: const Text(
                    "Koperasi Unit Desa",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.18),
                  child: Transform.scale(
                    scale: 1.3,
                    child: Image.asset(
                      'assets/images/Background Light.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _startPageController,
            children: [
              StartGuideLayout(
                title: "Mulai Perjalanan Bersama Kami!",
                subtitle:
                    "Jadilah bagian dari koperasi unit desa yang mengutamakan kebutuhan Anda.",
                imagePath: 'assets/images/Finance Analysis.png',
                onNextPressed: () {
                  _startPageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              ),
              GuideScreens(
                  _startPageController, _guidePageController, nextButtonText),
            ],
          ),
        ],
      ),
    );
  }
}

class GuideScreens extends StatelessWidget {
  final PageController startPageController;
  final PageController guidePageController;
  final String nextButtonText;
  final AuthService _authService = AuthService(); // Add AuthService

  GuideScreens(
    this.startPageController,
    this.guidePageController,
    this.nextButtonText, {
    super.key,
  });

  Future<void> _handleNavigation(BuildContext context) async {
    if (guidePageController.page?.round() == 2) {
      await _authService.markGuideAsShown(); // Mark guide as shown
      Navigator.pushReplacement( // Use pushReplacement instead of push
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AuthLayout(content: LoginScreen()),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      guidePageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: guidePageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GuideLayout(
              transformScale: 1.1,
              controller: guidePageController,
              title: "Nikmati Akses dan Layanan",
              subtitle:
                  "Selalu hadir untuk Anda, Bersama membangun Kesejahteraan.",
              imagePath: 'assets/images/Mobile Transaction.png',
            ),
            GuideLayout(
              transformScale: 1.35,
              controller: guidePageController,
              title: "Bersama untuk Keuntungan Bersama",
              subtitle:
                  "Bukan hanya soal transaksi, tapi juga berbagi manfaat untuk masa depan yang lebih cerah.",
              imagePath: 'assets/images/Money Management.png',
            ),
            GuideLayout(
              controller: guidePageController,
              title: "Keamanan Terjamin, Perlindungan Maksimal",
              subtitle:
                  "Dapatkan perlindungan menyeluruh dengan keamanan bersertifikat dari Koperasi Indonesia.",
              imagePath: 'assets/images/Money Management 2.png',
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
            child: Center(
              child: PageIndicatorWithButtons(
                controller: guidePageController,
                pageCount: 3,
                textNextButton: nextButtonText,
                onBackPressed: () {
                  if (guidePageController.page!.round() == 0) {
                    startPageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else {
                    guidePageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                onNextPressed: () => _handleNavigation(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageIndicatorWithButtons extends StatelessWidget {
  final PageController controller;
  final int pageCount;
  final String textNextButton;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;

  const PageIndicatorWithButtons({
    super.key,
    required this.controller,
    this.pageCount = 3,
    this.textNextButton = "Selanjutnya",
    required this.onBackPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SmoothPageIndicator(
          controller: controller,
          count: pageCount,
          effect: CustomizableEffect(
            activeDotDecoration: DotDecoration(
              width: 32,
              height: 10,
              color: const Color(0xFF43964F),
              borderRadius: BorderRadius.circular(6),
            ),
            dotDecoration: DotDecoration(
              width: 10,
              height: 10,
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onDotClicked: (index) {
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: button(
                onPressed: onBackPressed,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF43964F),
                text: "Kembali",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: button(
                onPressed: onNextPressed,
                backgroundColor: const Color(0xFF43964F),
                text: textNextButton,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
