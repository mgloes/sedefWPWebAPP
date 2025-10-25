import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@unfreezed
abstract class SettingsModel with _$SettingsModel {
  factory SettingsModel({
  int? id,
  bool? customerSelection

  }) = _SettingsModel;

  const SettingsModel._();
  
  factory SettingsModel.fromJson(Map<String, Object?> json) =>
      _$SettingsModelFromJson(json);
}
