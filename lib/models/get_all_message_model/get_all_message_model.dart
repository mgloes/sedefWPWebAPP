import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sedefwpwebapp/models/conversation_model/conversation_model.dart';
part 'get_all_message_model.freezed.dart';
part 'get_all_message_model.g.dart';

@unfreezed
abstract class GetAllMessageModel with _$GetAllMessageModel {
  factory GetAllMessageModel({
  String? lastMessage,
  DateTime? lastMessageDate,
  String? phoneNumber,
  String? phoneNumberNameSurname,
  String? assignedUserInfo,
  DateTime? assignedDate,
  bool? converisationStatus,
  ConversationModel? conversation

  }) = _GetAllMessageModel;

  const GetAllMessageModel._();
  
  factory GetAllMessageModel.fromJson(Map<String, Object?> json) =>
      _$GetAllMessageModelFromJson(json);
}
