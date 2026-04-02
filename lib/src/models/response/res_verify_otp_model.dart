import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'res_verify_otp_model.g.dart';

@JsonSerializable()
class ResVerifyOtpModel {
  final String? access_token;
  final String? token_type;

  ResVerifyOtpModel({
    this.access_token,
    this.token_type,
  });
  factory ResVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ResVerifyOtpModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResVerifyOtpModelToJson(this);
}
