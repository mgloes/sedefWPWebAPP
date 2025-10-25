// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationModel {

 int? get id; set id(int? value); DateTime? get createdDate; set createdDate(DateTime? value); DateTime? get updatedDate; set updatedDate(DateTime? value); bool? get status; set status(bool? value); String? get customerPhoneNumber; set customerPhoneNumber(String? value); String? get customerNameSurname; set customerNameSurname(String? value); int? get userId; set userId(int? value); String? get userNameSurname; set userNameSurname(String? value); String? get mainPhoneId; set mainPhoneId(String? value); DateTime? get conversationEndDate; set conversationEndDate(DateTime? value); String? get mainPhoneNumber; set mainPhoneNumber(String? value); bool? get isAnswered; set isAnswered(bool? value); int? get notAnsweredMessageCount; set notAnsweredMessageCount(int? value);
/// Create a copy of ConversationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationModelCopyWith<ConversationModel> get copyWith => _$ConversationModelCopyWithImpl<ConversationModel>(this as ConversationModel, _$identity);

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'ConversationModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, status: $status, customerPhoneNumber: $customerPhoneNumber, customerNameSurname: $customerNameSurname, userId: $userId, userNameSurname: $userNameSurname, mainPhoneId: $mainPhoneId, conversationEndDate: $conversationEndDate, mainPhoneNumber: $mainPhoneNumber, isAnswered: $isAnswered, notAnsweredMessageCount: $notAnsweredMessageCount)';
}


}

/// @nodoc
abstract mixin class $ConversationModelCopyWith<$Res>  {
  factory $ConversationModelCopyWith(ConversationModel value, $Res Function(ConversationModel) _then) = _$ConversationModelCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, bool? status, String? customerPhoneNumber, String? customerNameSurname, int? userId, String? userNameSurname, String? mainPhoneId, DateTime? conversationEndDate, String? mainPhoneNumber, bool? isAnswered, int? notAnsweredMessageCount
});




}
/// @nodoc
class _$ConversationModelCopyWithImpl<$Res>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._self, this._then);

  final ConversationModel _self;
  final $Res Function(ConversationModel) _then;

/// Create a copy of ConversationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? status = freezed,Object? customerPhoneNumber = freezed,Object? customerNameSurname = freezed,Object? userId = freezed,Object? userNameSurname = freezed,Object? mainPhoneId = freezed,Object? conversationEndDate = freezed,Object? mainPhoneNumber = freezed,Object? isAnswered = freezed,Object? notAnsweredMessageCount = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool?,customerPhoneNumber: freezed == customerPhoneNumber ? _self.customerPhoneNumber : customerPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,customerNameSurname: freezed == customerNameSurname ? _self.customerNameSurname : customerNameSurname // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userNameSurname: freezed == userNameSurname ? _self.userNameSurname : userNameSurname // ignore: cast_nullable_to_non_nullable
as String?,mainPhoneId: freezed == mainPhoneId ? _self.mainPhoneId : mainPhoneId // ignore: cast_nullable_to_non_nullable
as String?,conversationEndDate: freezed == conversationEndDate ? _self.conversationEndDate : conversationEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,mainPhoneNumber: freezed == mainPhoneNumber ? _self.mainPhoneNumber : mainPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isAnswered: freezed == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool?,notAnsweredMessageCount: freezed == notAnsweredMessageCount ? _self.notAnsweredMessageCount : notAnsweredMessageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationModel].
extension ConversationModelPatterns on ConversationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationModel value)  $default,){
final _that = this;
switch (_that) {
case _ConversationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  bool? status,  String? customerPhoneNumber,  String? customerNameSurname,  int? userId,  String? userNameSurname,  String? mainPhoneId,  DateTime? conversationEndDate,  String? mainPhoneNumber,  bool? isAnswered,  int? notAnsweredMessageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.status,_that.customerPhoneNumber,_that.customerNameSurname,_that.userId,_that.userNameSurname,_that.mainPhoneId,_that.conversationEndDate,_that.mainPhoneNumber,_that.isAnswered,_that.notAnsweredMessageCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  bool? status,  String? customerPhoneNumber,  String? customerNameSurname,  int? userId,  String? userNameSurname,  String? mainPhoneId,  DateTime? conversationEndDate,  String? mainPhoneNumber,  bool? isAnswered,  int? notAnsweredMessageCount)  $default,) {final _that = this;
switch (_that) {
case _ConversationModel():
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.status,_that.customerPhoneNumber,_that.customerNameSurname,_that.userId,_that.userNameSurname,_that.mainPhoneId,_that.conversationEndDate,_that.mainPhoneNumber,_that.isAnswered,_that.notAnsweredMessageCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  bool? status,  String? customerPhoneNumber,  String? customerNameSurname,  int? userId,  String? userNameSurname,  String? mainPhoneId,  DateTime? conversationEndDate,  String? mainPhoneNumber,  bool? isAnswered,  int? notAnsweredMessageCount)?  $default,) {final _that = this;
switch (_that) {
case _ConversationModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.status,_that.customerPhoneNumber,_that.customerNameSurname,_that.userId,_that.userNameSurname,_that.mainPhoneId,_that.conversationEndDate,_that.mainPhoneNumber,_that.isAnswered,_that.notAnsweredMessageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationModel extends ConversationModel {
   _ConversationModel({this.id, this.createdDate, this.updatedDate, this.status, this.customerPhoneNumber, this.customerNameSurname, this.userId, this.userNameSurname, this.mainPhoneId, this.conversationEndDate, this.mainPhoneNumber, this.isAnswered, this.notAnsweredMessageCount}): super._();
  factory _ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);

@override  int? id;
@override  DateTime? createdDate;
@override  DateTime? updatedDate;
@override  bool? status;
@override  String? customerPhoneNumber;
@override  String? customerNameSurname;
@override  int? userId;
@override  String? userNameSurname;
@override  String? mainPhoneId;
@override  DateTime? conversationEndDate;
@override  String? mainPhoneNumber;
@override  bool? isAnswered;
@override  int? notAnsweredMessageCount;

/// Create a copy of ConversationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationModelCopyWith<_ConversationModel> get copyWith => __$ConversationModelCopyWithImpl<_ConversationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationModelToJson(this, );
}



@override
String toString() {
  return 'ConversationModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, status: $status, customerPhoneNumber: $customerPhoneNumber, customerNameSurname: $customerNameSurname, userId: $userId, userNameSurname: $userNameSurname, mainPhoneId: $mainPhoneId, conversationEndDate: $conversationEndDate, mainPhoneNumber: $mainPhoneNumber, isAnswered: $isAnswered, notAnsweredMessageCount: $notAnsweredMessageCount)';
}


}

/// @nodoc
abstract mixin class _$ConversationModelCopyWith<$Res> implements $ConversationModelCopyWith<$Res> {
  factory _$ConversationModelCopyWith(_ConversationModel value, $Res Function(_ConversationModel) _then) = __$ConversationModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, bool? status, String? customerPhoneNumber, String? customerNameSurname, int? userId, String? userNameSurname, String? mainPhoneId, DateTime? conversationEndDate, String? mainPhoneNumber, bool? isAnswered, int? notAnsweredMessageCount
});




}
/// @nodoc
class __$ConversationModelCopyWithImpl<$Res>
    implements _$ConversationModelCopyWith<$Res> {
  __$ConversationModelCopyWithImpl(this._self, this._then);

  final _ConversationModel _self;
  final $Res Function(_ConversationModel) _then;

/// Create a copy of ConversationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? status = freezed,Object? customerPhoneNumber = freezed,Object? customerNameSurname = freezed,Object? userId = freezed,Object? userNameSurname = freezed,Object? mainPhoneId = freezed,Object? conversationEndDate = freezed,Object? mainPhoneNumber = freezed,Object? isAnswered = freezed,Object? notAnsweredMessageCount = freezed,}) {
  return _then(_ConversationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool?,customerPhoneNumber: freezed == customerPhoneNumber ? _self.customerPhoneNumber : customerPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,customerNameSurname: freezed == customerNameSurname ? _self.customerNameSurname : customerNameSurname // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userNameSurname: freezed == userNameSurname ? _self.userNameSurname : userNameSurname // ignore: cast_nullable_to_non_nullable
as String?,mainPhoneId: freezed == mainPhoneId ? _self.mainPhoneId : mainPhoneId // ignore: cast_nullable_to_non_nullable
as String?,conversationEndDate: freezed == conversationEndDate ? _self.conversationEndDate : conversationEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,mainPhoneNumber: freezed == mainPhoneNumber ? _self.mainPhoneNumber : mainPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isAnswered: freezed == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool?,notAnsweredMessageCount: freezed == notAnsweredMessageCount ? _self.notAnsweredMessageCount : notAnsweredMessageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
