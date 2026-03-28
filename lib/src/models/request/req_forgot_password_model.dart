import 'package:json_annotation/json_annotation.dart';

part 'req_forgot_password_model.g.dart';

@JsonSerializable()
class ReqForgotPasswordModel {
  final String email;

  ReqForgotPasswordModel({required this.email});

  factory ReqForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ReqForgotPasswordModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReqForgotPasswordModelToJson(this);
}
