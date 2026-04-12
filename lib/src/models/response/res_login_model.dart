import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/login_data_model.dart';

part 'res_login_model.g.dart';

@JsonSerializable()
class ResLoginModel {
  final LoginDataModel? data;
  final String? message;

  ResLoginModel({
    this.data,
    this.message,
  });

  factory ResLoginModel.fromJson(Map<String, dynamic> json) =>
      _$ResLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResLoginModelToJson(this);
}
