import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@unfreezed
abstract class UserModel with _$UserModel {
  factory UserModel({
  int? id,
  DateTime? createdDate,
  DateTime? updatedDate,
  String? emailAddress,
  String? password,
  String? name,
  String? surname,
  String? phoneNumberList,
  String? role,
  bool? status,
  String? description
  }) = _UserModel;

  const UserModel._();
  
  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
