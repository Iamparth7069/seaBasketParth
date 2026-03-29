import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/payment_intent_model.dart';

part 'res_payment_intent_model.g.dart';

@JsonSerializable()
class ResPaymentIntentModel {
  final PaymentIntentModel data;
  final String message;

  ResPaymentIntentModel({
    required this.data,
    required this.message,
  });

  factory ResPaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$ResPaymentIntentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResPaymentIntentModelToJson(this);
}
