// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    _ResponseModel(
      data: json['data'],
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'],
    );

Map<String, dynamic> _$ResponseModelToJson(_ResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
    };
