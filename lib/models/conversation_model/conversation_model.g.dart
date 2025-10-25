// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    _ConversationModel(
      id: (json['id'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      status: json['status'] as bool?,
      customerPhoneNumber: json['customerPhoneNumber'] as String?,
      customerNameSurname: json['customerNameSurname'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      userNameSurname: json['userNameSurname'] as String?,
      mainPhoneId: json['mainPhoneId'] as String?,
      conversationEndDate: json['conversationEndDate'] == null
          ? null
          : DateTime.parse(json['conversationEndDate'] as String),
      mainPhoneNumber: json['mainPhoneNumber'] as String?,
      isAnswered: json['isAnswered'] as bool?,
      notAnsweredMessageCount: (json['notAnsweredMessageCount'] as num?)
          ?.toInt(),
    );

Map<String, dynamic> _$ConversationModelToJson(_ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'status': instance.status,
      'customerPhoneNumber': instance.customerPhoneNumber,
      'customerNameSurname': instance.customerNameSurname,
      'userId': instance.userId,
      'userNameSurname': instance.userNameSurname,
      'mainPhoneId': instance.mainPhoneId,
      'conversationEndDate': instance.conversationEndDate?.toIso8601String(),
      'mainPhoneNumber': instance.mainPhoneNumber,
      'isAnswered': instance.isAnswered,
      'notAnsweredMessageCount': instance.notAnsweredMessageCount,
    };
