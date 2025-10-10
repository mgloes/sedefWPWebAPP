// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_message_for_main_phones_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetAllMessageForMainPhonesModel _$GetAllMessageForMainPhonesModelFromJson(
  Map<String, dynamic> json,
) => _GetAllMessageForMainPhonesModel(
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => GetAllMessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$GetAllMessageForMainPhonesModelToJson(
  _GetAllMessageForMainPhonesModel instance,
) => <String, dynamic>{
  'messages': instance.messages,
  'phoneNumber': instance.phoneNumber,
};
