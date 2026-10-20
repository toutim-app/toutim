// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_with_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemWithFields {

 Item get item; Map<String, FieldValue> get fieldValues;
/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemWithFieldsCopyWith<ItemWithFields> get copyWith => _$ItemWithFieldsCopyWithImpl<ItemWithFields>(this as ItemWithFields, _$identity);

  /// Serializes this ItemWithFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemWithFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemWithFields&&(identical(other.item, _this.item) || other.item == _this.item)&&const DeepCollectionEquality().equals(other.fieldValues, _this.fieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemWithFields;
  return Object.hash(runtimeType,_this.item,const DeepCollectionEquality().hash(_this.fieldValues));
}

@override
String toString() {
  final _this = this as ItemWithFields;
  return 'ItemWithFields(item: ${_this.item}, fieldValues: ${_this.fieldValues})';
}


}

/// @nodoc
abstract mixin class $ItemWithFieldsCopyWith<$Res>  {
  factory $ItemWithFieldsCopyWith(ItemWithFields value, $Res Function(ItemWithFields) _then) = _$ItemWithFieldsCopyWithImpl;
@useResult
$Res call({
 Item item, Map<String, FieldValue> fieldValues
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class _$ItemWithFieldsCopyWithImpl<$Res>
    implements $ItemWithFieldsCopyWith<$Res> {
  _$ItemWithFieldsCopyWithImpl(this._self, this._then);

  final ItemWithFields _self;
  final $Res Function(ItemWithFields) _then;

/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? fieldValues = null,}) {
  return _then(ItemWithFields(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,fieldValues: null == fieldValues ? _self.fieldValues : fieldValues // ignore: cast_nullable_to_non_nullable
as Map<String, FieldValue>,
  ));
}
/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemWithFields].
extension ItemWithFieldsPatterns on ItemWithFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemWithFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemWithFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemWithFields value)  $default,){
final _that = this;
switch (_that) {
case _ItemWithFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemWithFields value)?  $default,){
final _that = this;
switch (_that) {
case _ItemWithFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Item item,  Map<String, FieldValue> fieldValues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemWithFields() when $default != null:
return $default(_that.item,_that.fieldValues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Item item,  Map<String, FieldValue> fieldValues)  $default,) {final _that = this;
switch (_that) {
case _ItemWithFields():
return $default(_that.item,_that.fieldValues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Item item,  Map<String, FieldValue> fieldValues)?  $default,) {final _that = this;
switch (_that) {
case _ItemWithFields() when $default != null:
return $default(_that.item,_that.fieldValues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemWithFields implements ItemWithFields {
  const _ItemWithFields({required this.item,  Map<String, FieldValue> fieldValues = const {}}): _fieldValues = fieldValues;
  factory _ItemWithFields.fromJson(Map<String, dynamic> json) => _$ItemWithFieldsFromJson(json);

@override final  Item item;
 final  Map<String, FieldValue> _fieldValues;
@override@JsonKey() Map<String, FieldValue> get fieldValues {
  if (_fieldValues is EqualUnmodifiableMapView) return _fieldValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldValues);
}


/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemWithFieldsCopyWith<_ItemWithFields> get copyWith => __$ItemWithFieldsCopyWithImpl<_ItemWithFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemWithFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemWithFields&&(identical(other.item, item) || other.item == item)&&const DeepCollectionEquality().equals(other.fieldValues, _fieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,item,const DeepCollectionEquality().hash(_fieldValues));
}

@override
String toString() {
    return 'ItemWithFields(item: $item, fieldValues: $fieldValues)';
}


}

/// @nodoc
abstract mixin class _$ItemWithFieldsCopyWith<$Res> implements $ItemWithFieldsCopyWith<$Res> {
  factory _$ItemWithFieldsCopyWith(_ItemWithFields value, $Res Function(_ItemWithFields) _then) = __$ItemWithFieldsCopyWithImpl;
@override @useResult
$Res call({
 Item item, Map<String, FieldValue> fieldValues
});


@override $ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ItemWithFieldsCopyWithImpl<$Res>
    implements _$ItemWithFieldsCopyWith<$Res> {
  __$ItemWithFieldsCopyWithImpl(this._self, this._then);

  final _ItemWithFields _self;
  final $Res Function(_ItemWithFields) _then;

/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? fieldValues = null,}) {
  return _then(_ItemWithFields(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,fieldValues: null == fieldValues ? _self._fieldValues : fieldValues // ignore: cast_nullable_to_non_nullable
as Map<String, FieldValue>,
  ));
}

/// Create a copy of ItemWithFields
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
