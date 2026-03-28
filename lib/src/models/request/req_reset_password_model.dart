import 'package:json_annotation/json_annotation.dart';

part 'req_reset_password_model.g.dart';

@JsonSerializable()
class ReqResetPasswordModel {
  final String password;

  ReqResetPasswordModel({required this.password});

  factory ReqResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ReqResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqResetPasswordModelToJson(this);
}
