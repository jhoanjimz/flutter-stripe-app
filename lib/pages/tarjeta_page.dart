import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:stripe_app/bloc/bloc.dart';
import 'package:stripe_app/widgets/widgets.dart';


class TarjetaPage extends StatelessWidget {
  const TarjetaPage({super.key});

  @override
  Widget build(BuildContext context) {

    final pagarBloc = BlocProvider.of<PagarBloc>(context);
    final tarjeta = pagarBloc.state.tarjeta!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            pagarBloc.add(OnDesactivarTarjeta());
            Navigator.pop(context);
          }, 
        ),
      ),
      body:  Stack(
        children: [
          Container(),
          Hero(
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
          const Positioned(
            bottom: 0,
            child: TotalPayButton(),
          )
        ],
      )
    );
  }
}