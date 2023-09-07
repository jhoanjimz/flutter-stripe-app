// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/services.dart';

class TotalPayButton extends StatelessWidget {
  const TotalPayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${pagarBloc.state.montoPagar} ${pagarBloc.state.moneda}',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
        BlocBuilder<PagarBloc, PagarState>(
          builder: (context, state) {
            return _BtnPay( state );
          },
        )
      ]),
    );
  }
}

class _BtnPay extends StatelessWidget {

  final PagarState state;

  const _BtnPay(this.state);

  @override
  Widget build(BuildContext context) {
    return state.tarjetaActiva
    ? buildButtonTarjeta(context)
    : buildAppleAndGooglePay(context);
  }

  Widget buildButtonTarjeta(BuildContext context) {

    final tarjeta = BlocProvider.of<PagarBloc>(context).state.tarjeta!;
    final mesAnio = tarjeta.expiracyDate.split('/');
    final amount = BlocProvider.of<PagarBloc>(context).state.montoPagarString;
    final currency = BlocProvider.of<PagarBloc>(context).state.moneda;
    final stripeService = StripeService();
    
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: const Row(
        children: [
          Icon(FontAwesomeIcons.solidCreditCard, color: Colors.white),
          Text('  Pagar', style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
      onPressed: () async {
        try {
          mostrarLoading(context);
          final paymentIntent = await stripeService.paymentIntent({'amount': amount,'currency': currency});
          final confirmPaymentIntent = await stripeService.confirmPaymentIntentSaveCard(
            card: CardDetails(
              number: tarjeta.cardNumber, expirationMonth: int.parse(mesAnio[0]),
              expirationYear: int.parse(mesAnio[1]), cvc: tarjeta.cvv
            ),
            paymentIntent: paymentIntent
          );
          Navigator.pop(context);
          if ( !confirmPaymentIntent.ok ) { mostrarAlerta(context, 'Pago anulado', confirmPaymentIntent.msg!); }
          else { mostrarAlerta(context, 'Pago exitoso', confirmPaymentIntent.msg!); }
        } catch (e) {
          Navigator.pop(context);
          mostrarAlerta(context, 'Pago anulado', '$e');
        }
      },
    );
  }
}

Widget buildAppleAndGooglePay(BuildContext context) {
  return MaterialButton(
    height: 45,
    minWidth: 150,
    shape: const StadiumBorder(),
    elevation: 0,
    color: Colors.black,
    child: Row(
      children: [
        Icon(
          Platform.isAndroid ? FontAwesomeIcons.google : FontAwesomeIcons.apple,
          color: Colors.white
        ),
        const Text(' Pay', style: TextStyle(color: Colors.white, fontSize: 22))
      ],
    ),
    onPressed: () async {
    }
  );
}
