import 'package:flutter/material.dart';
import 'package:stripe_app/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StripeApp',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => const HomePage(),
        'tarjeta': (_) => const TarjetaPage(),
        'pago_completo': (_) => const PagoCompletoPage()
      },
      theme: ThemeData().copyWith(
        primaryColor: const Color(0xff284879),
        scaffoldBackgroundColor: const Color(0xff21232A),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff284879))
      ),
    );
  }
}