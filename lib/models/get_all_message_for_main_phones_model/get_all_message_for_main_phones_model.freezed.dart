// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_all_message_for_main_phones_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetAllMessageForMainPhonesModel {

 List<GetAllMessageModel>? get messages; set messages(List<GetAllMessageModel>? value); String? get phoneNumber; set phoneNumber(String? value);
/// Create a copy of GetAllMessageForMainPhonesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAllMessageForMainPhonesModelCopyWith<GetAllMessageForMainPhonesModel> get copyWith => _$GetAllMessageForMainPhonesModelCopyWithImpl<GetAllMessageForMainPhonesModel>(this as GetAllMessageForMainPhonesModel, _$identity);

  /// Serializes this GetAllMessageForMainPhonesModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'GetAllMessageForMainPhonesModel(messages: $messages, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $GetAllMessageForMainPhonesModelCopyWith<$Res>  {
  factory $GetAllMessageForMainPhonesModelCopyWith(GetAllMessageForMainPhonesModel value, $Res Function(GetAllMessageForMainPhonesModel) _then) = _$GetAllMessageForMainPhonesModelCopyWithImpl;
@useResult
$Res call({
 List<GetAllMessageModel>? messages, String? phoneNumber
});




}
/// @nodoc
class _$GetAllMessageForMainPhonesModelCopyWithImpl<$Res>
    implements $GetAllMessageForMainPhonesModelCopyWith<$Res> {
  _$GetAllMessageForMainPhonesModelCopyWithImpl(this._self, this._then);

  final GetAllMessageForMainPhonesModel _self;
  final $Res Function(GetAllMessageForMainPhonesModel) _then;

/// Create a copy of GetAllMessageForMainPhonesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = freezed,Object? phoneNumber = freezed,}) {
  return _then(_self.copyWith(
messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<GetAllMessageModel>?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetAllMessageForMainPhonesModel].
extension GetAllMessageForMainPhonesModelPatterns on GetAllMessageForMainPhonesModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAllMessageForMainPhonesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAllMessageForMainPhonesModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAllMessageForMainPhonesModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GetAllMessageModel>? messages,  String? phoneNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel() when $default != null:
return $default(_that.messages,_that.phoneNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GetAllMessageModel>? messages,  String? phoneNumber)  $default,) {final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel():
return $default(_that.messages,_that.phoneNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GetAllMessageModel>? messages,  String? phoneNumber)?  $default,) {final _that = this;
switch (_that) {
case _GetAllMessageForMainPhonesModel() when $default != null:
return $default(_that.messages,_that.phoneNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAllMessageForMainPhonesModel extends GetAllMessageForMainPhonesModel {
   _GetAllMessageForMainPhonesModel({this.messages, this.phoneNumber}): super._();
  factory _GetAllMessageForMainPhonesModel.fromJson(Map<String, dynamic> json) => _$GetAllMessageForMainPhonesModelFromJson(json);

@override  List<GetAllMessageModel>? messages;
@override  String? phoneNumber;

/// Create a copy of GetAllMessageForMainPhonesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAllMessageForMainPhonesModelCopyWith<_GetAllMessageForMainPhonesModel> get copyWith => __$GetAllMessageForMainPhonesModelCopyWithImpl<_GetAllMessageForMainPhonesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAllMessageForMainPhonesModelToJson(this, );
}



@override
String toString() {
  return 'GetAllMessageForMainPhonesModel(messages: $messages, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$GetAllMessageForMainPhonesModelCopyWith<$Res> implements $GetAllMessageForMainPhonesModelCopyWith<$Res> {
  factory _$GetAllMessageForMainPhonesModelCopyWith(_GetAllMessageForMainPhonesModel value, $Res Function(_GetAllMessageForMainPhonesModel) _then) = __$GetAllMessageForMainPhonesModelCopyWithImpl;
@override @useResult
$Res call({
 List<GetAllMessageModel>? messages, String? phoneNumber
});




}
/// @nodoc
class __$GetAllMessageForMainPhonesModelCopyWithImpl<$Res>
    implements _$GetAllMessageForMainPhonesModelCopyWith<$Res> {
  __$GetAllMessageForMainPhonesModelCopyWithImpl(this._self, this._then);

  final _GetAllMessageForMainPhonesModel _self;
  final $Res Function(_GetAllMessageForMainPhonesModel) _then;

/// Create a copy of GetAllMessageForMainPhonesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = freezed,Object? phoneNumber = freezed,}) {
  return _then(_GetAllMessageForMainPhonesModel(
messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<GetAllMessageModel>?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
