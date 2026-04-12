import 'package:json_annotation/json_annotation.dart';
part 'req_update_profile_model.g.dart';

@JsonSerializable()
class ReqUpdateProfileModel {
  final String? phoneNumber;
  final String? address;
  ReqUpdateProfileModel({
    this.phoneNumber,
    this.address,
  });

  factory ReqUpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ReqUpdateProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReqUpdateProfileModelToJson(this);
}
