import 'package:json_annotation/json_annotation.dart';

part 'req_verify_otp_model.g.dart';

@JsonSerializable()
class ReqVerifyOtpModel {
  final String OTP;

  ReqVerifyOtpModel({required this.OTP});

  factory ReqVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ReqVerifyOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqVerifyOtpModelToJson(this);
}
