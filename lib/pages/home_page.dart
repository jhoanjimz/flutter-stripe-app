// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/bloc.dart';
import 'package:stripe_app/data/data.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/pages.dart';
import 'package:stripe_app/services/services.dart';
import 'package:stripe_app/widgets/widgets.dart';


class HomePage extends StatelessWidget {
  
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final amount = BlocProvider.of<PagarBloc>(context).state.montoPagarString;
    final currency = BlocProvider.of<PagarBloc>(context).state.moneda;
    final stripeService = StripeService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              try {
                mostrarLoading(context);
                final paymentIntent = await stripeService.paymentIntent({'amount': amount,'currency': currency});
                final initPaymentSheet = await stripeService.initPaymentSheet(paymentIntent: paymentIntent);
                if ( !initPaymentSheet.ok ) { 
                  Navigator.pop(context);
                  return mostrarAlerta(context, 'Pago anulado', initPaymentSheet.msg!); 
                }
                final presentPaymentSheet = await stripeService.presentPaymentSheet();
                Navigator.pop(context);
                if ( !presentPaymentSheet.ok ) { mostrarAlerta(context, 'Pago anulado', presentPaymentSheet.msg!); }
                else { mostrarAlerta(context, 'Pago exitoso', presentPaymentSheet.msg!); }
              } catch (e) {
                Navigator.pop(context);
                mostrarAlerta(context, 'Pago anulado', '$e');
              }
            }, 
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              physics: const BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: (_, i) {
                final tarjeta = tarjetas[i];
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<PagarBloc>(context).add(OnSeleccionarTarjeta(tarjeta));
                    Navigator.push(context, navegarFadeIn(context, const TarjetaPage()));
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: tarjeta.cardNumberHidden,
                      cardHolderName: tarjeta.cardHolderName,
                      expiryDate: tarjeta.expiracyDate,
                      cvvCode: tarjeta.cvv,
                      isHolderNameVisible: true,
                      showBackView: false, 
                      onCreditCardWidgetChange:(CreditCardBrand creditCardBrand) {},
                    ),
                  ),
                );
              }
            ),
          ),
          const Positioned(
            bottom: 0,
            child: TotalPayButton(),
          )
        ],
      )
    );
  }
}