import 'package:freezed_annotation/freezed_annotation.dart';
part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@unfreezed
abstract class ConversationModel with _$ConversationModel {
  factory ConversationModel({
  int? id,
  DateTime? createdDate,
  DateTime? updatedDate,
  bool? status,
  String? customerPhoneNumber,
  String? customerNameSurname,
  int? userId,
  String? userNameSurname,
  String? mainPhoneId,
  DateTime? conversationEndDate,
  String? mainPhoneNumber,
  bool? isAnswered,
  int? notAnsweredMessageCount

  }) = _ConversationModel;

  const ConversationModel._();
  
  factory ConversationModel.fromJson(Map<String, Object?> json) =>
      _$ConversationModelFromJson(json);
}
