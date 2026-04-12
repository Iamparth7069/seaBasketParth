import 'package:json_annotation/json_annotation.dart';

part 'req_verify_otp_model.g.dart';

@JsonSerializable()
class ReqVerifyOtpModel {
  @JsonKey(name: "OTP")
  final String otp;

  ReqVerifyOtpModel({required this.otp});

  factory ReqVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ReqVerifyOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqVerifyOtpModelToJson(this);
}
