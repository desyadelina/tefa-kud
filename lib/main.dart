// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tefa_kud/Start/screens/mutasi/mutasi_page.dart';
import 'package:tefa_kud/screens/intro/splash_screen.dart';
import 'package:tefa_kud/screens/isi_saldo/isi_saldo.dart';
import 'package:tefa_kud/screens/profile/profile_edit_screen.dart';
import 'package:tefa_kud/screens/profile/profile_screen.dart';
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
import 'package:tefa_kud/widget/layout/detailed_layout.dart';
import 'package:tefa_kud/widget/layout/main_layout.dart';

class NavigatorManager {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Widget getRouteWidget(String routeName) {
    switch (routeName) {
      case '/profileEdit':
        return const ProfileEditScreen();
      case '/MutasiPage':
        return const MutasiPage(
          titleBar: 'Mutasi',
          background: Colors.white,
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
      default:
        return MainLayout(
          title: '',
        );
    }
  }
}

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      navigatorKey: NavigatorManager.navigatorKey,
      routes: {
        '/': (context) => const MainLayout(
              title: '',
            ),
        '/splashscreen': (context) => const SplashScreen(),
        '/MutasiPage': (context) => const MutasiPage(
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
        '/ConfirmTarikTunai': (context) => const DetailedPage(
              titleBar: "Tarik Tunai",
              background: Colors.white,
              content: ConfirmTarikTunai(
                title: '',
                nominalTarikTunai: 0,
                noRekPengguna: '',
                userSlug: '',
              ),
            ),
        '/InputPinTarikTunai': (context) => const DetailedPage(
              titleBar: "Tarik Tunai",
              background: Colors.white,
              content: InputPinTarikTunai(
                title: '',
                noRekPengguna: '',
                userSlug: '',
                namaPengguna: '',
                nominalTarikTunai: 0,
              ),
            ),
        '/CodeTarikTunai': (context) => const DetailedPage(
              titleBar: "Tarik Tunai",
              background: Colors.white,
              content: CodeTarikTunai(
                title: '',
                nominal: '',
                date: '',
              ),
            ),
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
        '/pinjaman': (context) => DetailedPage(
              content: PinjamanPage(
                title: '',
              ),
              background: Colors.white,
              titleBar: "Pinjaman",
            ),
        '/InputPinPinjaman': (context) => DetailedPage(
              content: InputPinPinjaman(
                title: '',
              ),
              background: Colors.white,
              titleBar: "Pinjaman",
            ),
        '/CodePinjaman': (context) => DetailedPage(
              content: CodePinjaman(
                title: '',
                nominal: '',
                date: '',
              ),
              background: Color(0xFFF9F9F9),
              titleBar: "Pinjaman",
            ),
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
        '/profileEdit': (context) => const DetailedPage(
              content: ProfileEditScreen(),
              background: Color(0xFFF2F2F2),
            ),
      },
      theme: ThemeData(
        fontFamily: 'RedRose',
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
