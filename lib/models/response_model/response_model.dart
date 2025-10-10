import 'package:freezed_annotation/freezed_annotation.dart';
part 'response_model.freezed.dart';
part 'response_model.g.dart';

@unfreezed
abstract class ResponseModel with _$ResponseModel {
  factory ResponseModel({
  dynamic data,
  bool? isSuccess,
  dynamic message
  }) = _ResponseModel;

  const ResponseModel._();
  
  factory ResponseModel.fromJson(Map<String, Object?> json) =>
      _$ResponseModelFromJson(json);
}
