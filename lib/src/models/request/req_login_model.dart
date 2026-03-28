import 'package:json_annotation/json_annotation.dart';

part 'req_login_model.g.dart';

@JsonSerializable()
class ReqLoginModel {
  final String username;
  final String password;

  ReqLoginModel({
    required this.username,
    required this.password,
  });

  factory ReqLoginModel.fromJson(Map<String, dynamic> json) =>
      _$ReqLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqLoginModelToJson(this);
}
