import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sedefwpwebapp/models/get_all_message_model/get_all_message_model.dart';
part 'get_all_message_for_main_phones_model.freezed.dart';
part 'get_all_message_for_main_phones_model.g.dart';

@unfreezed
abstract class GetAllMessageForMainPhonesModel with _$GetAllMessageForMainPhonesModel {
  factory GetAllMessageForMainPhonesModel({
  List<GetAllMessageModel>? messages,
  String? phoneNumber

  }) = _GetAllMessageForMainPhonesModel;

  const GetAllMessageForMainPhonesModel._();
  
  factory GetAllMessageForMainPhonesModel.fromJson(Map<String, Object?> json) =>
      _$GetAllMessageForMainPhonesModelFromJson(json);
}
