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
  emailAddress: json['emailAddress'] as String?,
  password: json['password'] as String?,
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  phoneNumberList: json['phoneNumberList'] as String?,
  role: json['role'] as String?,
  status: json['status'] as bool?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'emailAddress': instance.emailAddress,
      'password': instance.password,
      'name': instance.name,
      'surname': instance.surname,
      'phoneNumberList': instance.phoneNumberList,
      'role': instance.role,
      'status': instance.status,
    };
