// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetAllMessageModel _$GetAllMessageModelFromJson(Map<String, dynamic> json) =>
    _GetAllMessageModel(
      lastMessage: json['lastMessage'] as String?,
      lastMessageDate: json['lastMessageDate'] == null
          ? null
          : DateTime.parse(json['lastMessageDate'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      phoneNumberNameSurname: json['phoneNumberNameSurname'] as String?,
    );

Map<String, dynamic> _$GetAllMessageModelToJson(_GetAllMessageModel instance) =>
    <String, dynamic>{
      'lastMessage': instance.lastMessage,
      'lastMessageDate': instance.lastMessageDate?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'phoneNumberNameSurname': instance.phoneNumberNameSurname,
    };
