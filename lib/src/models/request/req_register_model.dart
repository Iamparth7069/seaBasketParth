import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/request/req_user_model.dart';
import 'package:seabasket/src/models/user.dart';

part 'req_register_model.g.dart';

@JsonSerializable()
class ReqRegisterModel {
  final ReqUserModel user;

  ReqRegisterModel({required this.user});

  factory ReqRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$ReqRegisterModelFromJson(json);

  Map<String, dynamic> toJson() => user.toJson();
}
