// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageModel {

 int? get id; set id(int? value); DateTime? get createdDate; set createdDate(DateTime? value); DateTime? get updatedDate; set updatedDate(DateTime? value); String? get senderPhoneNumber; set senderPhoneNumber(String? value); String? get senderNameSurname; set senderNameSurname(String? value); String? get receiverPhoneNumber; set receiverPhoneNumber(String? value); String? get messageType; set messageType(String? value); String? get messageId; set messageId(String? value); String? get imageCaption; set imageCaption(String? value); String? get imageUrl; set imageUrl(String? value); String? get textBody; set textBody(String? value); bool? get isConversation; set isConversation(bool? value); String? get timestamp; set timestamp(String? value);
/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageModelCopyWith<MessageModel> get copyWith => _$MessageModelCopyWithImpl<MessageModel>(this as MessageModel, _$identity);

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'MessageModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, senderPhoneNumber: $senderPhoneNumber, senderNameSurname: $senderNameSurname, receiverPhoneNumber: $receiverPhoneNumber, messageType: $messageType, messageId: $messageId, imageCaption: $imageCaption, imageUrl: $imageUrl, textBody: $textBody, isConversation: $isConversation, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $MessageModelCopyWith<$Res>  {
  factory $MessageModelCopyWith(MessageModel value, $Res Function(MessageModel) _then) = _$MessageModelCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, String? senderPhoneNumber, String? senderNameSurname, String? receiverPhoneNumber, String? messageType, String? messageId, String? imageCaption, String? imageUrl, String? textBody, bool? isConversation, String? timestamp
});




}
/// @nodoc
class _$MessageModelCopyWithImpl<$Res>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._self, this._then);

  final MessageModel _self;
  final $Res Function(MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? senderPhoneNumber = freezed,Object? senderNameSurname = freezed,Object? receiverPhoneNumber = freezed,Object? messageType = freezed,Object? messageId = freezed,Object? imageCaption = freezed,Object? imageUrl = freezed,Object? textBody = freezed,Object? isConversation = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,senderPhoneNumber: freezed == senderPhoneNumber ? _self.senderPhoneNumber : senderPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,senderNameSurname: freezed == senderNameSurname ? _self.senderNameSurname : senderNameSurname // ignore: cast_nullable_to_non_nullable
as String?,receiverPhoneNumber: freezed == receiverPhoneNumber ? _self.receiverPhoneNumber : receiverPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,imageCaption: freezed == imageCaption ? _self.imageCaption : imageCaption // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,textBody: freezed == textBody ? _self.textBody : textBody // ignore: cast_nullable_to_non_nullable
as String?,isConversation: freezed == isConversation ? _self.isConversation : isConversation // ignore: cast_nullable_to_non_nullable
as bool?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageModel].
extension MessageModelPatterns on MessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageModel value)  $default,){
final _that = this;
switch (_that) {
case _MessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? senderPhoneNumber,  String? senderNameSurname,  String? receiverPhoneNumber,  String? messageType,  String? messageId,  String? imageCaption,  String? imageUrl,  String? textBody,  bool? isConversation,  String? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.senderPhoneNumber,_that.senderNameSurname,_that.receiverPhoneNumber,_that.messageType,_that.messageId,_that.imageCaption,_that.imageUrl,_that.textBody,_that.isConversation,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? senderPhoneNumber,  String? senderNameSurname,  String? receiverPhoneNumber,  String? messageType,  String? messageId,  String? imageCaption,  String? imageUrl,  String? textBody,  bool? isConversation,  String? timestamp)  $default,) {final _that = this;
switch (_that) {
case _MessageModel():
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.senderPhoneNumber,_that.senderNameSurname,_that.receiverPhoneNumber,_that.messageType,_that.messageId,_that.imageCaption,_that.imageUrl,_that.textBody,_that.isConversation,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime? createdDate,  DateTime? updatedDate,  String? senderPhoneNumber,  String? senderNameSurname,  String? receiverPhoneNumber,  String? messageType,  String? messageId,  String? imageCaption,  String? imageUrl,  String? textBody,  bool? isConversation,  String? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.createdDate,_that.updatedDate,_that.senderPhoneNumber,_that.senderNameSurname,_that.receiverPhoneNumber,_that.messageType,_that.messageId,_that.imageCaption,_that.imageUrl,_that.textBody,_that.isConversation,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageModel extends MessageModel {
   _MessageModel({this.id, this.createdDate, this.updatedDate, this.senderPhoneNumber, this.senderNameSurname, this.receiverPhoneNumber, this.messageType, this.messageId, this.imageCaption, this.imageUrl, this.textBody, this.isConversation, this.timestamp}): super._();
  factory _MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

@override  int? id;
@override  DateTime? createdDate;
@override  DateTime? updatedDate;
@override  String? senderPhoneNumber;
@override  String? senderNameSurname;
@override  String? receiverPhoneNumber;
@override  String? messageType;
@override  String? messageId;
@override  String? imageCaption;
@override  String? imageUrl;
@override  String? textBody;
@override  bool? isConversation;
@override  String? timestamp;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageModelCopyWith<_MessageModel> get copyWith => __$MessageModelCopyWithImpl<_MessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageModelToJson(this, );
}



@override
String toString() {
  return 'MessageModel(id: $id, createdDate: $createdDate, updatedDate: $updatedDate, senderPhoneNumber: $senderPhoneNumber, senderNameSurname: $senderNameSurname, receiverPhoneNumber: $receiverPhoneNumber, messageType: $messageType, messageId: $messageId, imageCaption: $imageCaption, imageUrl: $imageUrl, textBody: $textBody, isConversation: $isConversation, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$MessageModelCopyWith<$Res> implements $MessageModelCopyWith<$Res> {
  factory _$MessageModelCopyWith(_MessageModel value, $Res Function(_MessageModel) _then) = __$MessageModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime? createdDate, DateTime? updatedDate, String? senderPhoneNumber, String? senderNameSurname, String? receiverPhoneNumber, String? messageType, String? messageId, String? imageCaption, String? imageUrl, String? textBody, bool? isConversation, String? timestamp
});




}
/// @nodoc
class __$MessageModelCopyWithImpl<$Res>
    implements _$MessageModelCopyWith<$Res> {
  __$MessageModelCopyWithImpl(this._self, this._then);

  final _MessageModel _self;
  final $Res Function(_MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdDate = freezed,Object? updatedDate = freezed,Object? senderPhoneNumber = freezed,Object? senderNameSurname = freezed,Object? receiverPhoneNumber = freezed,Object? messageType = freezed,Object? messageId = freezed,Object? imageCaption = freezed,Object? imageUrl = freezed,Object? textBody = freezed,Object? isConversation = freezed,Object? timestamp = freezed,}) {
  return _then(_MessageModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,senderPhoneNumber: freezed == senderPhoneNumber ? _self.senderPhoneNumber : senderPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,senderNameSurname: freezed == senderNameSurname ? _self.senderNameSurname : senderNameSurname // ignore: cast_nullable_to_non_nullable
as String?,receiverPhoneNumber: freezed == receiverPhoneNumber ? _self.receiverPhoneNumber : receiverPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,imageCaption: freezed == imageCaption ? _self.imageCaption : imageCaption // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,textBody: freezed == textBody ? _self.textBody : textBody // ignore: cast_nullable_to_non_nullable
as String?,isConversation: freezed == isConversation ? _self.isConversation : isConversation // ignore: cast_nullable_to_non_nullable
as bool?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
