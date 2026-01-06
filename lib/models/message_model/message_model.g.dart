// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: (json['id'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      senderPhoneNumber: json['senderPhoneNumber'] as String?,
      senderNameSurname: json['senderNameSurname'] as String?,
      receiverPhoneNumber: json['receiverPhoneNumber'] as String?,
      receiverNameSurname: json['receiverNameSurname'] as String?,
      messageType: json['messageType'] as String?,
      messageId: json['messageId'] as String?,
      imageCaption: json['imageCaption'] as String?,
      imageUrl: json['imageUrl'] as String?,
      textBody: json['textBody'] as String?,
      isConversation: json['isConversation'] as bool?,
      timestamp: json['timestamp'] as String?,
      conversation: json['conversation'] == null
          ? null
          : ConversationModel.fromJson(
              json['conversation'] as Map<String, dynamic>,
            ),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationUrl: json['locationUrl'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'senderPhoneNumber': instance.senderPhoneNumber,
      'senderNameSurname': instance.senderNameSurname,
      'receiverPhoneNumber': instance.receiverPhoneNumber,
      'receiverNameSurname': instance.receiverNameSurname,
      'messageType': instance.messageType,
      'messageId': instance.messageId,
      'imageCaption': instance.imageCaption,
      'imageUrl': instance.imageUrl,
      'textBody': instance.textBody,
      'isConversation': instance.isConversation,
      'timestamp': instance.timestamp,
      'conversation': instance.conversation,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locationUrl': instance.locationUrl,
    };
