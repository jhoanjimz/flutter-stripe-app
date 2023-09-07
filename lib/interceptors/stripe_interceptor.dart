import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.headers.addAll({ 
      'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    super.onRequest(options, handler);
  }

}