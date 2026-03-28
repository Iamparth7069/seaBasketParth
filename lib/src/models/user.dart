import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? username;
  final String email;
  final String? hashedPassword;
  final String? phoneNumber;
  final String? address;

  User({
    this.id,
    this.username,
    required this.email,
    this.hashedPassword,
    this.phoneNumber,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
