// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhoneNumberModel _$PhoneNumberModelFromJson(Map<String, dynamic> json) =>
    _PhoneNumberModel(
      id: (json['id'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      title: json['title'] as String?,
      phoneNumberId: json['phoneNumberId'] as String?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$PhoneNumberModelToJson(_PhoneNumberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'title': instance.title,
      'phoneNumberId': instance.phoneNumberId,
      'status': instance.status,
    };
