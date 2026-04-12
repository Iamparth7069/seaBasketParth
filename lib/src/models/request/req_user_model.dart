import 'package:json_annotation/json_annotation.dart';

part 'req_user_model.g.dart';

@JsonSerializable()
class ReqUserModel {
  @JsonKey(name: 'userName')
  final String? username;
  final String email;
  final String? phoneNumber;
  final String? hashedPassword;

  ReqUserModel({
    this.username,
    required this.email,
    this.phoneNumber,
    this.hashedPassword,
  });

  factory ReqUserModel.fromJson(Map<String, dynamic> json) =>
      _$ReqUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqUserModelToJson(this);
}
