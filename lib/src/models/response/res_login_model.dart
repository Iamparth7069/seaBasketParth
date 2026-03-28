import 'package:json_annotation/json_annotation.dart';

part 'res_login_model.g.dart';

@JsonSerializable()
class ResLoginModel {
  final String? access_token;
  final String? token_type;
  final String? email;
  final String? message;

  ResLoginModel({
    this.access_token,
    this.token_type,
    this.email,
    this.message,
  });

  factory ResLoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final model = _$ResLoginModelFromJson(data);

    return ResLoginModel(
      access_token: model.access_token,
      token_type: model.token_type,
      email: model.email,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => _$ResLoginModelToJson(this);
}
