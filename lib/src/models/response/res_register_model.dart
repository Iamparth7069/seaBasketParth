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

  factory ResRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$ResRegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResRegisterModelToJson(this);
}
