// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_all_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetAllMessageModel {

 String? get lastMessage; set lastMessage(String? value); DateTime? get lastMessageDate; set lastMessageDate(DateTime? value); String? get phoneNumber; set phoneNumber(String? value); String? get phoneNumberNameSurname; set phoneNumberNameSurname(String? value); String? get assignedUserInfo; set assignedUserInfo(String? value); DateTime? get assignedDate; set assignedDate(DateTime? value); bool? get converisationStatus; set converisationStatus(bool? value); ConversationModel? get conversation; set conversation(ConversationModel? value);
/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAllMessageModelCopyWith<GetAllMessageModel> get copyWith => _$GetAllMessageModelCopyWithImpl<GetAllMessageModel>(this as GetAllMessageModel, _$identity);

  /// Serializes this GetAllMessageModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'GetAllMessageModel(lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, phoneNumber: $phoneNumber, phoneNumberNameSurname: $phoneNumberNameSurname, assignedUserInfo: $assignedUserInfo, assignedDate: $assignedDate, converisationStatus: $converisationStatus, conversation: $conversation)';
}


}

/// @nodoc
abstract mixin class $GetAllMessageModelCopyWith<$Res>  {
  factory $GetAllMessageModelCopyWith(GetAllMessageModel value, $Res Function(GetAllMessageModel) _then) = _$GetAllMessageModelCopyWithImpl;
@useResult
$Res call({
 String? lastMessage, DateTime? lastMessageDate, String? phoneNumber, String? phoneNumberNameSurname, String? assignedUserInfo, DateTime? assignedDate, bool? converisationStatus, ConversationModel? conversation
});


$ConversationModelCopyWith<$Res>? get conversation;

}
/// @nodoc
class _$GetAllMessageModelCopyWithImpl<$Res>
    implements $GetAllMessageModelCopyWith<$Res> {
  _$GetAllMessageModelCopyWithImpl(this._self, this._then);

  final GetAllMessageModel _self;
  final $Res Function(GetAllMessageModel) _then;

/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastMessage = freezed,Object? lastMessageDate = freezed,Object? phoneNumber = freezed,Object? phoneNumberNameSurname = freezed,Object? assignedUserInfo = freezed,Object? assignedDate = freezed,Object? converisationStatus = freezed,Object? conversation = freezed,}) {
  return _then(_self.copyWith(
lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDate: freezed == lastMessageDate ? _self.lastMessageDate : lastMessageDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberNameSurname: freezed == phoneNumberNameSurname ? _self.phoneNumberNameSurname : phoneNumberNameSurname // ignore: cast_nullable_to_non_nullable
as String?,assignedUserInfo: freezed == assignedUserInfo ? _self.assignedUserInfo : assignedUserInfo // ignore: cast_nullable_to_non_nullable
as String?,assignedDate: freezed == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,converisationStatus: freezed == converisationStatus ? _self.converisationStatus : converisationStatus // ignore: cast_nullable_to_non_nullable
as bool?,conversation: freezed == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as ConversationModel?,
  ));
}
/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationModelCopyWith<$Res>? get conversation {
    if (_self.conversation == null) {
    return null;
  }

  return $ConversationModelCopyWith<$Res>(_self.conversation!, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetAllMessageModel].
extension GetAllMessageModelPatterns on GetAllMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAllMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAllMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAllMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAllMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAllMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAllMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? lastMessage,  DateTime? lastMessageDate,  String? phoneNumber,  String? phoneNumberNameSurname,  String? assignedUserInfo,  DateTime? assignedDate,  bool? converisationStatus,  ConversationModel? conversation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAllMessageModel() when $default != null:
return $default(_that.lastMessage,_that.lastMessageDate,_that.phoneNumber,_that.phoneNumberNameSurname,_that.assignedUserInfo,_that.assignedDate,_that.converisationStatus,_that.conversation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? lastMessage,  DateTime? lastMessageDate,  String? phoneNumber,  String? phoneNumberNameSurname,  String? assignedUserInfo,  DateTime? assignedDate,  bool? converisationStatus,  ConversationModel? conversation)  $default,) {final _that = this;
switch (_that) {
case _GetAllMessageModel():
return $default(_that.lastMessage,_that.lastMessageDate,_that.phoneNumber,_that.phoneNumberNameSurname,_that.assignedUserInfo,_that.assignedDate,_that.converisationStatus,_that.conversation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? lastMessage,  DateTime? lastMessageDate,  String? phoneNumber,  String? phoneNumberNameSurname,  String? assignedUserInfo,  DateTime? assignedDate,  bool? converisationStatus,  ConversationModel? conversation)?  $default,) {final _that = this;
switch (_that) {
case _GetAllMessageModel() when $default != null:
return $default(_that.lastMessage,_that.lastMessageDate,_that.phoneNumber,_that.phoneNumberNameSurname,_that.assignedUserInfo,_that.assignedDate,_that.converisationStatus,_that.conversation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAllMessageModel extends GetAllMessageModel {
   _GetAllMessageModel({this.lastMessage, this.lastMessageDate, this.phoneNumber, this.phoneNumberNameSurname, this.assignedUserInfo, this.assignedDate, this.converisationStatus, this.conversation}): super._();
  factory _GetAllMessageModel.fromJson(Map<String, dynamic> json) => _$GetAllMessageModelFromJson(json);

@override  String? lastMessage;
@override  DateTime? lastMessageDate;
@override  String? phoneNumber;
@override  String? phoneNumberNameSurname;
@override  String? assignedUserInfo;
@override  DateTime? assignedDate;
@override  bool? converisationStatus;
@override  ConversationModel? conversation;

/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAllMessageModelCopyWith<_GetAllMessageModel> get copyWith => __$GetAllMessageModelCopyWithImpl<_GetAllMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAllMessageModelToJson(this, );
}



@override
String toString() {
  return 'GetAllMessageModel(lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, phoneNumber: $phoneNumber, phoneNumberNameSurname: $phoneNumberNameSurname, assignedUserInfo: $assignedUserInfo, assignedDate: $assignedDate, converisationStatus: $converisationStatus, conversation: $conversation)';
}


}

/// @nodoc
abstract mixin class _$GetAllMessageModelCopyWith<$Res> implements $GetAllMessageModelCopyWith<$Res> {
  factory _$GetAllMessageModelCopyWith(_GetAllMessageModel value, $Res Function(_GetAllMessageModel) _then) = __$GetAllMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String? lastMessage, DateTime? lastMessageDate, String? phoneNumber, String? phoneNumberNameSurname, String? assignedUserInfo, DateTime? assignedDate, bool? converisationStatus, ConversationModel? conversation
});


@override $ConversationModelCopyWith<$Res>? get conversation;

}
/// @nodoc
class __$GetAllMessageModelCopyWithImpl<$Res>
    implements _$GetAllMessageModelCopyWith<$Res> {
  __$GetAllMessageModelCopyWithImpl(this._self, this._then);

  final _GetAllMessageModel _self;
  final $Res Function(_GetAllMessageModel) _then;

/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastMessage = freezed,Object? lastMessageDate = freezed,Object? phoneNumber = freezed,Object? phoneNumberNameSurname = freezed,Object? assignedUserInfo = freezed,Object? assignedDate = freezed,Object? converisationStatus = freezed,Object? conversation = freezed,}) {
  return _then(_GetAllMessageModel(
lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDate: freezed == lastMessageDate ? _self.lastMessageDate : lastMessageDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberNameSurname: freezed == phoneNumberNameSurname ? _self.phoneNumberNameSurname : phoneNumberNameSurname // ignore: cast_nullable_to_non_nullable
as String?,assignedUserInfo: freezed == assignedUserInfo ? _self.assignedUserInfo : assignedUserInfo // ignore: cast_nullable_to_non_nullable
as String?,assignedDate: freezed == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,converisationStatus: freezed == converisationStatus ? _self.converisationStatus : converisationStatus // ignore: cast_nullable_to_non_nullable
as bool?,conversation: freezed == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as ConversationModel?,
  ));
}

/// Create a copy of GetAllMessageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationModelCopyWith<$Res>? get conversation {
    if (_self.conversation == null) {
    return null;
  }

  return $ConversationModelCopyWith<$Res>(_self.conversation!, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}

// dart format on
