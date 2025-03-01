// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tefa_kud/Start/screens/mutasi/mutasi_page.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/list_bayar_pinjaman.dart';
import 'package:tefa_kud/screens/bayar_pinjaman/receipt_bayar_pinjaman.dart';
import 'package:tefa_kud/screens/intro/login_page.dart';
import 'package:tefa_kud/screens/intro/splash_screen.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/profile/ganti_pin/new_pin_screen.dart';
import 'package:tefa_kud/screens/profile/ganti_pin/prev_pin_screen.dart';
import 'package:tefa_kud/screens/profile/profile_edit_screen.dart';
import 'package:tefa_kud/screens/profile/profile_page.dart';
import 'package:tefa_kud/screens/tarik_tunai/tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/confirm_page_transfer.dart';
import 'package:tefa_kud/screens/transfer/input_pin_transfer.dart';
import 'package:tefa_kud/screens/transfer/list_transfer.dart';
import 'package:tefa_kud/screens/isi_saldo/code_isi_saldo.dart';
import 'package:tefa_kud/screens/isi_saldo/confirm_isi_saldo.dart';
import 'package:tefa_kud/screens/isi_saldo/input_pin_isi_saldo.dart';
import 'package:tefa_kud/screens/isi_saldo/receipt_isi_saldo.dart';
import 'package:tefa_kud/screens/pinjaman/code_pinjaman.dart';
import 'package:tefa_kud/screens/pinjaman/input_pin_pinjaman.dart';
import 'package:tefa_kud/screens/pinjaman/pinjaman_page.dart';
import 'package:tefa_kud/screens/pinjaman/receipt_pinjaman.dart';
import 'package:tefa_kud/screens/tarik_tunai/code_tarik_tunai.dart';
import 'package:tefa_kud/screens/tarik_tunai/confirm_tarik_tunai.dart';
import 'package:tefa_kud/screens/tarik_tunai/input_pin_tarik_tunai.dart';
import 'package:tefa_kud/screens/tarik_tunai/receipt_tarik_tunai.dart';
import 'package:tefa_kud/screens/transfer/input_nominal_transfer.dart';
import 'package:tefa_kud/screens/transfer/receipt_transfer.dart';
import 'package:tefa_kud/screens/transfer/transfer_new_rek.dart';
import 'package:tefa_kud/services/auth_service.dart';
import 'package:tefa_kud/widget/layout/auth_layout.dart';
import 'package:tefa_kud/widget/layout/detailed_layout.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tefa_kud/screens/home_page.dart';
import 'package:tefa_kud/providers/bottom_bar_visibility_provider.dart';

class NavigatorManager {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Widget getRouteWidget(String routeName) {
    switch (routeName) {
      case '/profileEdit':
        return const ProfileEditScreen();
      case '/profile':
        return ProfilePage();
      case '/MutasiPage':
        return DetailedPage(
          titleBar: 'Mutasi Page',
          content: MutasiPage(
            titleBar: 'Mutasi',
            background: Colors.white,
          ),
        );
      case '/transfer':
        return ListTransfer();
      case '/tarikTunai':
        return TarikTunaiPage(
          title: '',
        );
      case '/pinjaman':
        return PinjamanPage(
          title: '',
        );
      case '/ListBayarPinjaman':
        return ListBayarPinjaman(
          title: 'Bayar Pinjaman',
        );
      case '/PreviousPinPage':
        return PreviousPinPage(
          title: '',
          userSlug: '',
          noRekPengguna: '',
        );
      case '/NewPinPage':
        return NewPinPage(
          title: '',
          userSlug: '',
          noRekPengguna: '',
        );
      default:
        return MainLayout(
          title: '',
        );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthService authService = AuthService();
  final bool isLoggedIn = await authService.isLoggedIn();
  final String initialRoute = isLoggedIn ? '/home' : '/splashscreen';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomBarVisibilityProvider()),
      ],
      child: MainApp(initialRoute: initialRoute),
    ),
  );
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  MainApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      navigatorKey: NavigatorManager.navigatorKey,
      routes: {
        // Add login route
        '/login': (context) => const AuthLayout(content: LoginScreen()),

        // Protected routes
        '/': (context) => const MainLayout(title: ''),
        '/splashscreen': (context) => const SplashScreen(),
        '/MutasiPage': (context) => MutasiPage(
              titleBar: 'Mutasi',
              background: Colors.white,
            ),
        '/profile': (context) => ProfilePage(),
        '/transfer': (context) => const DetailedPage(
              titleBar: "Transfer",
              background: Colors.white,
              content: ListTransfer(),
            ),
        '/TransferNewRek': (context) => const DetailedPage(
              titleBar: "Transfer",
              background: Colors.white,
              content: TransferNewRek(
                title: '',
              ),
            ),
        '/InputNominalTransfer': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Transfer",
            background: Colors.white,
            content: InputNominalTransfer(
              title: args['title'] ?? '',
              rekeningTujuan: args['rekeningTujuan'] ?? '',
              userSlug: args['userSlug'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
            ),
          );
        },
        '/ConfirmTransfer': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Transfer",
            background: Colors.white,
            content: ConfirmTransfer(
              title: args['title'] ?? '',
              nominalTransfer: args['nominalTransfer'] ?? 0,
              noRekPengguna: args['noRekPengguna'] ?? '',
              noRekTujuan: args['noRekTujuan'] ?? '',
              userSlug: args['userSlug'] ?? '',
            ),
          );
        },
        '/ConfirmationPinTransfer': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Transfer",
            background: Colors.white,
            content: InputPinTransfer(
              title: args['title'] ?? '',
              userSlug: args['userSlug'] ?? '',
              noRekTujuan: args['noRekTujuan'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
              nominalTransfer: args['nominalTransfer'] ?? 0,
              namaPenerima: args['namaPenerima'] ?? '',
            ),
          );
        },
        '/ReceiptTransfer': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Transfer",
            background: Color(0xFF43964F),
            content: ReceiptTransfer(
              nominal: args['nominal'] ?? 0,
              date: args['date'] ?? '',
              title: args['title'] ?? '',
              namaPenerima: args['namaPenerima'] ?? '',
              rekeningTujuan: args['rekeningTujuan'] ?? '',
            ),
          );
        },
        '/isiSaldo': (context) => const DetailedPage(
              titleBar: "Isi Saldo",
              background: Colors.white,
              content: IsiSaldoPage(title: ''),
            ),
        '/ConfirmIsiSaldo': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Isi Saldo",
            background: Colors.white,
            content: ConfirmIsiSaldo(
              title: args['title'] ?? '',
              nominalIsiSaldo: args['nominalIsiSaldo'] ?? 0,
              noRekPengguna: args['noRekPengguna'] ?? '',
              userSlug: args['userSlug'] ?? '',
            ),
          );
        },
        '/InputPinIsiSaldo': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Isi Saldo",
            background: Colors.white,
            content: InputPinIsiSaldo(
              title: args['title'] ?? '',
              userSlug: args['userSlug'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
              nominalIsiSaldo: args['nominalIsiSaldo'] ?? 0,
              namaPengguna: args['namaPengguna'] ?? '',
            ),
          );
        },
        '/CodeIsiSaldo': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return DetailedPage(
            titleBar: "Isi Saldo",
            background: Colors.white,
            content: CodeIsiSaldo(
              title: args?['title'] ?? '',
              nominal: args?['nominal']?.toString() ?? '0',
              date: args?['date'] ?? DateTime.now().toString(),
              noRekPengguna: args?['noRekPengguna'] ?? '',
              namaPengguna: args?['namaPengguna'] ?? '',
            ),
          );
        },
        '/ReceiptIsiSaldo': (context) => const DetailedPage(
              titleBar: "Isi Saldo",
              background: Color(0xFF43964F),
              content: ReceiptIsiSaldo(
                title: '',
                nominal: '',
                date: '',
                namaPengguna: '',
                noRekPengguna: '',
              ),
            ),
        '/tarikTunai': (context) => const DetailedPage(
              titleBar: "Tarik Tunai",
              background: Colors.white,
              content: TarikTunaiPage(title: ''),
            ),
        '/ConfirmTarikTunai': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Tarik Tunai",
            background: Colors.white,
            content: ConfirmTarikTunai(
              title: args['title'] ?? '',
              nominalTarikTunai: args['nominalTarikTunai'] ?? 0,
              noRekPengguna: args['noRekPengguna'] ?? '',
              userSlug: args['userSlug'] ?? '',
            ),
          );
        },
        '/InputPinTarikTunai': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Tarik Tunai",
            background: Colors.white,
            content: InputPinTarikTunai(
              title: args['title'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
              userSlug: args['userSlug'] ?? '',
              namaPengguna: args['namaPengguna'] ?? '',
              nominalTarikTunai: args['nominalTarikTunai'] ?? 0,
            ),
          );
        },
        '/CodeTarikTunai': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return DetailedPage(
            titleBar: "Tarik Tunai",
            background: Colors.white,
            content: CodeTarikTunai(
              title: args?['title'] ?? '',
              nominal: args?['nominal']?.toString() ?? '0',
              date: args?['date'] ?? DateTime.now().toString(),
              noRekPengguna: args?['noRekPengguna'] ?? '',
              namaPengguna: args?['namaPengguna'] ?? '',
            ),
          );
        },
        '/ReceiptTarikTunai': (context) => DetailedPage(
              titleBar: "Tarik Tunai",
              background: const Color(0xFF43964F),
              content: ReceiptTarikTunai(
                title: '',
                nominal: '',
                date: '',
                namaPengguna: '',
                noRekPengguna: '',
              ),
            ),
        '/pinjaman': (context) => const DetailedPage(
              titleBar: "Pinjaman",
              background: Colors.white,
              content: PinjamanPage(title: ''),
            ),
        '/InputPinPinjaman': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Pinjaman",
            background: Colors.white,
            content: InputPinPinjaman(
              title: args['title'] ?? '',
              userSlug: args['userSlug'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
              nominalPinjaman: args['nominalPinjaman'] ?? 0,
              tenor: args['tenor'] ?? '',
            ),
          );
        },
        '/CodePinjaman': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return DetailedPage(
            titleBar: "Pinjaman",
            background: Color(0xFFF9F9F9),
            content: CodePinjaman(
              title: args?['title'] ?? '',
              nominal: args?['nominal']?.toString() ?? '0',
              date: args?['date'] ?? DateTime.now().toString(),
              noRekPengguna: args?['noRekPengguna'] ?? '',
              tenor: args?['tenor'] ?? '',
            ),
          );
        },
        '/ReceiptPinjaman': (context) => DetailedPage(
              content: ReceiptPinjaman(
                title: '',
                nominal: '',
                date: '',
                receiverName: '',
                accountNumber: '',
              ),
              background: Color(0xFF43964F),
              titleBar: "Pinjaman",
            ),
        '/ListBayarPinjaman': (context) => DetailedPage(
              content: ListBayarPinjaman(
                title: 'Bayar Pinjaman',
              ),
              background: Colors.white,
              titleBar: "Bayar Pinjaman",
            ),
        '/ReceiptBayarPinjaman': (context) {
          // Add the ReceiptBayarPinjaman route
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          return DetailedPage(
            titleBar: "Bayar Pinjaman",
            background: Color(0xFF43964F),
            content: ReceiptBayarPinjaman(
              title: args['title'] ?? '',
              nominal: args['nominal'] ?? '',
              date: args['date'] ?? '',
              namaPengguna: args['namaPengguna'] ?? '',
              noRekPengguna: args['noRekPengguna'] ?? '',
            ),
          );
        },
        '/PreviousPinPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return DetailedPage(
            titleBar: "Pinjaman",
            background: Color(0xFFF9F9F9),
            content: PreviousPinPage(
              title: args?['title'] ?? '',
              userSlug: args?['userSlug'] ?? '',
              noRekPengguna: args?['noRekPengguna'] ?? '',
            ),
          );
        },
        '/NewPinPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return DetailedPage(
            titleBar: "Pinjaman",
            background: Color(0xFFF9F9F9),
            content: NewPinPage(
              title: args?['title'] ?? '',
              userSlug: args?['userSlug'] ?? '',
              noRekPengguna: args?['noRekPengguna'] ?? '',
            ),
          );
        },
        '/home': (context) => const HomePage(),
      },

      // Add route guard
      onGenerateRoute: (settings) {
        // List of routes that don't need auth
        final publicRoutes = ['/splashscreen', '/login'];

        if (!publicRoutes.contains(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<bool>(
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
                  // User is logged in, get route widget from NavigatorManager
                  return NavigatorManager.getRouteWidget(settings.name ?? '/');
                } else {
                  // Not logged in, redirect to login
                  return const AuthLayout(content: LoginScreen());
                }
              },
            ),
          );
        }
        // Let MaterialApp handle public routes normally
        return null;
      },

      theme: ThemeData(
        fontFamily: 'RedRose',
        textTheme: const TextTheme( 
          bodyLarge: TextStyle(fontFamily: 'RedRose'),
          bodyMedium: TextStyle(fontFamily: 'RedRose'),
          titleLarge: TextStyle(fontFamily: 'RedRose'),
          titleMedium: TextStyle(fontFamily: 'RedRose'),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF43964F),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
