import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_model.g.dart';

@JsonSerializable()
class PaymentIntentModel {
  @JsonKey(name: 'client_secret')
  final String? clientSecret;
  @JsonKey(name: 'payment_intent_id')
  final String? paymentIntentId;
  final double? amount;

  PaymentIntentModel({
    this.clientSecret,
    this.paymentIntentId,
    this.amount,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentModelToJson(this);
}
