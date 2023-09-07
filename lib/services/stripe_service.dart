import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_app/interceptors/interceptors.dart';
import 'package:stripe_app/models/models.dart';

class StripeService {

  final Dio dioStripe;
  final String baseUrlStripe = 'https://api.stripe.com/v1';

  StripeService(): dioStripe = Dio()..interceptors.add(StripeInterceptor());

  Future<PaymentIntentResponse> paymentIntent( Map<String, dynamic> body ) async {
    final url = '$baseUrlStripe/payment_intents';
    final resp = await dioStripe.post(url, data: body);
    return PaymentIntentResponse.fromMap(resp.data);
  }


  Future<StripeCustomResponse> initPaymentSheet({
    required PaymentIntentResponse paymentIntent
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Prospects',
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntent.clientSecret,
          style: ThemeMode.light,
        )
      );
      return StripeCustomResponse(ok: true, msg: 'initPaymentSheet');
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: '$e');
    }
  }
  Future<StripeCustomResponse> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return StripeCustomResponse(ok: true, msg: 'Pago realizado con exito');
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: '$e');
    }
  }


  Future<StripeCustomResponse> confirmPaymentIntentSaveCard({
    required CardDetails card, 
    required PaymentIntentResponse paymentIntent
  }) async {
    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(card);
      const billingDetails = BillingDetails();
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent.clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
        ),
      );
      return StripeCustomResponse(ok: true, msg: 'Pago realizado con exito');
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: '$e');
    }
  }
  Future<StripeCustomResponse> confirmPaymentIntentNewCard({
    required PaymentIntentResponse paymentIntent
  }) async {
    try {
      const billingDetails = BillingDetails();
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent.clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
        ),
      );
      return StripeCustomResponse(ok: true, msg: 'Pago realizado con exito');
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: '$e');
    }
  }
}