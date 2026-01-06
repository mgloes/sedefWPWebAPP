import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sedefwpwebapp/models/conversation_model/conversation_model.dart';
part 'message_model.freezed.dart';
part 'message_model.g.dart';

@unfreezed
abstract class MessageModel with _$MessageModel {
  factory MessageModel({
  int? id,
  DateTime? createdDate,
  DateTime? updatedDate,
  String? senderPhoneNumber,
  String? senderNameSurname,
  String? receiverPhoneNumber,
  String? receiverNameSurname,
  String? messageType,
  String? messageId,
  String? imageCaption,
  String? imageUrl,
  String? textBody,
  bool? isConversation,
  String? timestamp,
  ConversationModel? conversation,
  double? latitude,
  double? longitude,
  String? locationUrl

  }) = _MessageModel;

  const MessageModel._();
  
  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}
