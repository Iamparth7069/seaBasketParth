import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/user.dart';

part 'res_register_model.g.dart';

@JsonSerializable()
class ResRegisterModel {
  final User? data;
  final String? message;

  ResRegisterModel({
    this.data,
    this.message,
  });

  factory ResRegisterModel.fromJson(Map<String, dynamic> json) {
    return ResRegisterModel(
      data: json['data'] != null ? User.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => _$ResRegisterModelToJson(this);
}
