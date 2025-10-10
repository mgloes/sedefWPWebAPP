// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_number_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhoneNumberModel {

 int? get id; set id(int? value); DateTime? get createdDate; set createdDate(DateTime? value); DateTime? get updatedDate; set updatedDate(DateTime? value); String? get phoneNumber; set phoneNumber(String? value); String? get title; set title(String? value); String? get phoneNumberId; set phoneNumberId(String? value); bool? get status; set status(bool? value);
/// Create a copy of PhoneNumberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneNumberModelCopyWith<PhoneNumberModel> get copyWith => _$PhoneNumberModelCopyWithImpl<PhoneNumberModel>(this as PhoneNumberModel, _$identity);

  /// Serializes this PhoneNumberModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'PhoneNumberModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, phoneNumber: $phoneNumber, title: $title, phoneNumberId: $phoneNumberId, status: $status)';
}


}

/// @nodoc
abstract mixin class $PhoneNumberModelCopyWith<$Res>  {
  factory $PhoneNumberModelCopyWith(PhoneNumberModel value, $Res Function(PhoneNumberModel) _then) = _$PhoneNumberModelCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, String? phoneNumber, String? title, String? phoneNumberId, bool? status
});




}
/// @nodoc
class _$PhoneNumberModelCopyWithImpl<$Res>
    implements $PhoneNumberModelCopyWith<$Res> {
  _$PhoneNumberModelCopyWithImpl(this._self, this._then);

  final PhoneNumberModel _self;
  final $Res Function(PhoneNumberModel) _then;

/// Create a copy of PhoneNumberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? phoneNumber = freezed,Object? title = freezed,Object? phoneNumberId = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberId: freezed == phoneNumberId ? _self.phoneNumberId : phoneNumberId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneNumberModel].
extension PhoneNumberModelPatterns on PhoneNumberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneNumberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneNumberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneNumberModel value)  $default,){
final _that = this;
switch (_that) {
case _PhoneNumberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneNumberModel value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneNumberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? phoneNumber,  String? title,  String? phoneNumberId,  bool? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneNumberModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.phoneNumber,_that.title,_that.phoneNumberId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? phoneNumber,  String? title,  String? phoneNumberId,  bool? status)  $default,) {final _that = this;
switch (_that) {
case _PhoneNumberModel():
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.phoneNumber,_that.title,_that.phoneNumberId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? phoneNumber,  String? title,  String? phoneNumberId,  bool? status)?  $default,) {final _that = this;
switch (_that) {
case _PhoneNumberModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.phoneNumber,_that.title,_that.phoneNumberId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneNumberModel extends PhoneNumberModel {
   _PhoneNumberModel({this.id, this.createdDate, this.updatedDate, this.phoneNumber, this.title, this.phoneNumberId, this.status}): super._();
  factory _PhoneNumberModel.fromJson(Map<String, dynamic> json) => _$PhoneNumberModelFromJson(json);

@override  int? id;
@override  DateTime? createdDate;
@override  DateTime? updatedDate;
@override  String? phoneNumber;
@override  String? title;
@override  String? phoneNumberId;
@override  bool? status;

/// Create a copy of PhoneNumberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneNumberModelCopyWith<_PhoneNumberModel> get copyWith => __$PhoneNumberModelCopyWithImpl<_PhoneNumberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneNumberModelToJson(this, );
}



@override
String toString() {
  return 'PhoneNumberModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, phoneNumber: $phoneNumber, title: $title, phoneNumberId: $phoneNumberId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PhoneNumberModelCopyWith<$Res> implements $PhoneNumberModelCopyWith<$Res> {
  factory _$PhoneNumberModelCopyWith(_PhoneNumberModel value, $Res Function(_PhoneNumberModel) _then) = __$PhoneNumberModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, String? phoneNumber, String? title, String? phoneNumberId, bool? status
});




}
/// @nodoc
class __$PhoneNumberModelCopyWithImpl<$Res>
    implements _$PhoneNumberModelCopyWith<$Res> {
  __$PhoneNumberModelCopyWithImpl(this._self, this._then);

  final _PhoneNumberModel _self;
  final $Res Function(_PhoneNumberModel) _then;

/// Create a copy of PhoneNumberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? phoneNumber = freezed,Object? title = freezed,Object? phoneNumberId = freezed,Object? status = freezed,}) {
  return _then(_PhoneNumberModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberId: freezed == phoneNumberId ? _self.phoneNumberId : phoneNumberId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
