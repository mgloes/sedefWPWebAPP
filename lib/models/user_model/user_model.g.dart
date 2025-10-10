// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num?)?.toInt(),
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
  updatedDate: json['updatedDate'] == null
      ? null
      : DateTime.parse(json['updatedDate'] as String),
  username: json['username'] as String?,
  password: json['password'] as String?,
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'username': instance.username,
      'password': instance.password,
      'name': instance.name,
      'surname': instance.surname,
      'role': instance.role,
    };
