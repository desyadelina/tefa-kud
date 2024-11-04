import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/loginForm.dart';
import 'package:tefa_kud/widget/button.dart';
import 'package:tefa_kud/widget/layout/guide_layout.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuideMain extends StatefulWidget {
  const GuideMain({super.key});

  @override
  State<GuideMain> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideMain> {
  final PageController _startPageController = PageController();
  final PageController _guidePageController = PageController();
  String nextButtonText = "Selanjutnya"; // Default text for the Next button

  @override
  void initState() {
    super.initState();
    _guidePageController.addListener(_updateNextButtonText);
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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 1.3,
              child: Image.asset(
                'assets/images/Background Light.png',
                fit: BoxFit.cover,
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

  const GuideScreens(
    this.startPageController,
    this.guidePageController,
    this.nextButtonText, {
    super.key,
  });

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
                onNextPressed: () {
                  if (guidePageController.page!.round() == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginMain(),
                      ),
                    );
                  } else {
                    guidePageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
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
