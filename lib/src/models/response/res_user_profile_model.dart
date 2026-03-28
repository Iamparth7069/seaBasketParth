import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/user.dart';

part 'res_user_profile_model.g.dart';

@JsonSerializable()
class ResUpdateProfileModel {
  final User? data;
  final String? message;

  ResUpdateProfileModel({this.data, this.message});

  factory ResUpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ResUpdateProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResUpdateProfileModelToJson(this);
}
