import 'package:freezed_annotation/freezed_annotation.dart';
part 'phone_number_model.freezed.dart';
part 'phone_number_model.g.dart';

@unfreezed
abstract class PhoneNumberModel with _$PhoneNumberModel {
  factory PhoneNumberModel({
  int? id,
  DateTime? createdDate,
  DateTime? updatedDate,
  String? phoneNumber,
  String? title,
  String? phoneNumberId,
  bool? status
  }) = _PhoneNumberModel;

  const PhoneNumberModel._();
  
  factory PhoneNumberModel.fromJson(Map<String, Object?> json) =>
      _$PhoneNumberModelFromJson(json);
}
