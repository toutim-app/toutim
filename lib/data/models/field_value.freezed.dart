// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldValue {

 String get id; String get itemId; String get fieldDefinitionId; dynamic get value; DateTime get updatedAt;
/// Create a copy of FieldValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldValueCopyWith<FieldValue> get copyWith => _$FieldValueCopyWithImpl<FieldValue>(this as FieldValue, _$identity);

  /// Serializes this FieldValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FieldValue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldValue&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.fieldDefinitionId, _this.fieldDefinitionId) || other.fieldDefinitionId == _this.fieldDefinitionId)&&const DeepCollectionEquality().equals(other.value, _this.value)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldValue;
  return Object.hash(runtimeType,_this.id,_this.itemId,_this.fieldDefinitionId,const DeepCollectionEquality().hash(_this.value),_this.updatedAt);
}

@override
String toString() {
  final _this = this as FieldValue;
  return 'FieldValue(id: ${_this.id}, itemId: ${_this.itemId}, fieldDefinitionId: ${_this.fieldDefinitionId}, value: ${_this.value}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FieldValueCopyWith<$Res>  {
  factory $FieldValueCopyWith(FieldValue value, $Res Function(FieldValue) _then) = _$FieldValueCopyWithImpl;
@useResult
$Res call({
 String id, String itemId, String fieldDefinitionId, dynamic value, DateTime updatedAt
});




}
/// @nodoc
class _$FieldValueCopyWithImpl<$Res>
    implements $FieldValueCopyWith<$Res> {
  _$FieldValueCopyWithImpl(this._self, this._then);

  final FieldValue _self;
  final $Res Function(FieldValue) _then;

/// Create a copy of FieldValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? fieldDefinitionId = null,Object? value = freezed,Object? updatedAt = null,}) {
  return _then(FieldValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,fieldDefinitionId: null == fieldDefinitionId ? _self.fieldDefinitionId : fieldDefinitionId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldValue].
extension FieldValuePatterns on FieldValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldValue value)  $default,){
final _that = this;
switch (_that) {
case _FieldValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldValue value)?  $default,){
final _that = this;
switch (_that) {
case _FieldValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemId,  String fieldDefinitionId,  dynamic value,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldValue() when $default != null:
return $default(_that.id,_that.itemId,_that.fieldDefinitionId,_that.value,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemId,  String fieldDefinitionId,  dynamic value,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FieldValue():
return $default(_that.id,_that.itemId,_that.fieldDefinitionId,_that.value,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemId,  String fieldDefinitionId,  dynamic value,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FieldValue() when $default != null:
return $default(_that.id,_that.itemId,_that.fieldDefinitionId,_that.value,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldValue implements FieldValue {
  const _FieldValue({required this.id, required this.itemId, required this.fieldDefinitionId, this.value, required this.updatedAt});
  factory _FieldValue.fromJson(Map<String, dynamic> json) => _$FieldValueFromJson(json);

@override final  String id;
@override final  String itemId;
@override final  String fieldDefinitionId;
@override final  dynamic value;
@override final  DateTime updatedAt;

/// Create a copy of FieldValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldValueCopyWith<_FieldValue> get copyWith => __$FieldValueCopyWithImpl<_FieldValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldValueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldValue&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.fieldDefinitionId, fieldDefinitionId) || other.fieldDefinitionId == fieldDefinitionId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,itemId,fieldDefinitionId,const DeepCollectionEquality().hash(value),updatedAt);
}

@override
String toString() {
    return 'FieldValue(id: $id, itemId: $itemId, fieldDefinitionId: $fieldDefinitionId, value: $value, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FieldValueCopyWith<$Res> implements $FieldValueCopyWith<$Res> {
  factory _$FieldValueCopyWith(_FieldValue value, $Res Function(_FieldValue) _then) = __$FieldValueCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemId, String fieldDefinitionId, dynamic value, DateTime updatedAt
});




}
/// @nodoc
class __$FieldValueCopyWithImpl<$Res>
    implements _$FieldValueCopyWith<$Res> {
  __$FieldValueCopyWithImpl(this._self, this._then);

  final _FieldValue _self;
  final $Res Function(_FieldValue) _then;

/// Create a copy of FieldValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? fieldDefinitionId = null,Object? value = freezed,Object? updatedAt = null,}) {
  return _then(_FieldValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,fieldDefinitionId: null == fieldDefinitionId ? _self.fieldDefinitionId : fieldDefinitionId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
