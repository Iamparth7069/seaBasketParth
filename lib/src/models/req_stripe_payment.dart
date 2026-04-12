import 'package:flutter_stripe/flutter_stripe.dart';

class ReqStripePaymentModel {
  final double amount;
  final String name;
  final String email;
  final String phone;
  final Address address;

  ReqStripePaymentModel({
    required this.amount,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}
