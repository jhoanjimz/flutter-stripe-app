// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_app/bloc/bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/services.dart';

class StripePage extends StatefulWidget {
  const StripePage({super.key});

  @override
  State<StripePage> createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {

  final controller = CardFormEditController();
  final stripeService = StripeService();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {
    controller.blur();
  });
  
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = BlocProvider.of<PagarBloc>(context).state.montoPagarString;
    final currency = BlocProvider.of<PagarBloc>(context).state.moneda;
    final stripeService = StripeService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( title: const Text('Form New Card') ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only( top: 20 ),
        child: Column(
          children: [
            CardFormField( controller: controller ),
            if(controller.details.complete == true)
            MaterialButton(
              onPressed: () async {
                try {
                  mostrarLoading(context);
                  final paymentIntent = await stripeService.paymentIntent({'amount': amount,'currency': currency});
                  final confirmPaymentIntent = await stripeService.confirmPaymentIntentNewCard(paymentIntent: paymentIntent);
                  Navigator.pop(context);
                  if ( !confirmPaymentIntent.ok ) { mostrarAlerta(context, 'Pago anulado', confirmPaymentIntent.msg!); }
                  else { mostrarAlerta(context, 'Pago exitoso', confirmPaymentIntent.msg!); }
                } catch (e) {
                  Navigator.pop(context);
                  mostrarAlerta(context, 'Pago anulado', '$e');
                }
              },
              color: const Color(0xff284879),
              elevation: 0,
              minWidth: 200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Text('Pagar', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}