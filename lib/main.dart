import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:stripe_app/bloc/bloc.dart';
import 'package:stripe_app/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = dotenv.env['STRIPE_APIKEY']!;
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PagarBloc()),
      ], 
      child: const StripeApp()
    )
  );
}
class StripeApp extends StatelessWidget {
  const StripeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StripeApp',
      // initialRoute: 'stripe_page',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => const HomePage(),
        'tarjeta': (_) => const TarjetaPage(),
        'pago_completo': (_) => const PagoCompletoPage(),
        'stripe_page': (_) => const StripePage(),
      },
      theme: ThemeData().copyWith(
        primaryColor: const Color(0xff284879),
        scaffoldBackgroundColor: const Color(0xff21232A),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff284879)),
      ),
    );
  }
}