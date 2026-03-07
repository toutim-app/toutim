// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FieldValue _$FieldValueFromJson(Map<String, dynamic> json) {
  return _FieldValue.fromJson(json);
}

/// @nodoc
mixin _$FieldValue {
  String get id => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get fieldDefinitionId => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FieldValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldValueCopyWith<FieldValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldValueCopyWith<$Res> {
  factory $FieldValueCopyWith(
    FieldValue value,
    $Res Function(FieldValue) then,
  ) = _$FieldValueCopyWithImpl<$Res, FieldValue>;
  @useResult
  $Res call({
    String id,
    String itemId,
    String fieldDefinitionId,
    dynamic value,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$FieldValueCopyWithImpl<$Res, $Val extends FieldValue>
    implements $FieldValueCopyWith<$Res> {
  _$FieldValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? fieldDefinitionId = null,
    Object? value = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as String,
            fieldDefinitionId: null == fieldDefinitionId
                ? _value.fieldDefinitionId
                : fieldDefinitionId // ignore: cast_nullable_to_non_nullable
                      as String,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FieldValueImplCopyWith<$Res>
    implements $FieldValueCopyWith<$Res> {
  factory _$$FieldValueImplCopyWith(
    _$FieldValueImpl value,
    $Res Function(_$FieldValueImpl) then,
  ) = __$$FieldValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String itemId,
    String fieldDefinitionId,
    dynamic value,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$FieldValueImplCopyWithImpl<$Res>
    extends _$FieldValueCopyWithImpl<$Res, _$FieldValueImpl>
    implements _$$FieldValueImplCopyWith<$Res> {
  __$$FieldValueImplCopyWithImpl(
    _$FieldValueImpl _value,
    $Res Function(_$FieldValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? fieldDefinitionId = null,
    Object? value = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _$FieldValueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String,
        fieldDefinitionId: null == fieldDefinitionId
            ? _value.fieldDefinitionId
            : fieldDefinitionId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldValueImpl implements _FieldValue {
  const _$FieldValueImpl({
    required this.id,
    required this.itemId,
    required this.fieldDefinitionId,
    this.value,
    required this.updatedAt,
  });

  factory _$FieldValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldValueImplFromJson(json);

  @override
  final String id;
  @override
  final String itemId;
  @override
  final String fieldDefinitionId;
  @override
  final dynamic value;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FieldValue(id: $id, itemId: $itemId, fieldDefinitionId: $fieldDefinitionId, value: $value, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldValueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.fieldDefinitionId, fieldDefinitionId) ||
                other.fieldDefinitionId == fieldDefinitionId) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    itemId,
    fieldDefinitionId,
    const DeepCollectionEquality().hash(value),
    updatedAt,
  );

  /// Create a copy of FieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldValueImplCopyWith<_$FieldValueImpl> get copyWith =>
      __$$FieldValueImplCopyWithImpl<_$FieldValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldValueImplToJson(this);
  }
}

abstract class _FieldValue implements FieldValue {
  const factory _FieldValue({
    required final String id,
    required final String itemId,
    required final String fieldDefinitionId,
    final dynamic value,
    required final DateTime updatedAt,
  }) = _$FieldValueImpl;

  factory _FieldValue.fromJson(Map<String, dynamic> json) =
      _$FieldValueImpl.fromJson;

  @override
  String get id;
  @override
  String get itemId;
  @override
  String get fieldDefinitionId;
  @override
  dynamic get value;
  @override
  DateTime get updatedAt;

  /// Create a copy of FieldValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldValueImplCopyWith<_$FieldValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
