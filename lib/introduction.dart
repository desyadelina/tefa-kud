import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transfer.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 50,
              height: 50,
            ),
            SizedBox(height: 20),

            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/introduction_image.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Mulai Perjalanan Bersama Kami!',
                    style: GoogleFonts.redRose( 
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Jadilah bagian dari koperasi unit desa yang mengutamakan kebutuhan Anda.',
                    style: GoogleFonts.redRose(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferScreen()));
                      },
                      child: Text(
                        'Mulai',
                        style: GoogleFonts.redRose(
                          color: Colors.white, 
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF43964F), 
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
