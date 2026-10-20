// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldDefinition {

 String get id; String get collectionId; String get name; FieldType get type; int get sortOrder; bool get isRequired; bool get showInList; bool get showInCard; bool get searchable; bool get sortable; dynamic get defaultValue; Map<String, dynamic> get options; SyncStatus get syncStatus; String? get serverId;
/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldDefinitionCopyWith<FieldDefinition> get copyWith => _$FieldDefinitionCopyWithImpl<FieldDefinition>(this as FieldDefinition, _$identity);

  /// Serializes this FieldDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FieldDefinition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldDefinition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.collectionId, _this.collectionId) || other.collectionId == _this.collectionId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isRequired, _this.isRequired) || other.isRequired == _this.isRequired)&&(identical(other.showInList, _this.showInList) || other.showInList == _this.showInList)&&(identical(other.showInCard, _this.showInCard) || other.showInCard == _this.showInCard)&&(identical(other.searchable, _this.searchable) || other.searchable == _this.searchable)&&(identical(other.sortable, _this.sortable) || other.sortable == _this.sortable)&&const DeepCollectionEquality().equals(other.defaultValue, _this.defaultValue)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.syncStatus, _this.syncStatus) || other.syncStatus == _this.syncStatus)&&(identical(other.serverId, _this.serverId) || other.serverId == _this.serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldDefinition;
  return Object.hash(runtimeType,_this.id,_this.collectionId,_this.name,_this.type,_this.sortOrder,_this.isRequired,_this.showInList,_this.showInCard,_this.searchable,_this.sortable,const DeepCollectionEquality().hash(_this.defaultValue),const DeepCollectionEquality().hash(_this.options),_this.syncStatus,_this.serverId);
}

@override
String toString() {
  final _this = this as FieldDefinition;
  return 'FieldDefinition(id: ${_this.id}, collectionId: ${_this.collectionId}, name: ${_this.name}, type: ${_this.type}, sortOrder: ${_this.sortOrder}, isRequired: ${_this.isRequired}, showInList: ${_this.showInList}, showInCard: ${_this.showInCard}, searchable: ${_this.searchable}, sortable: ${_this.sortable}, defaultValue: ${_this.defaultValue}, options: ${_this.options}, syncStatus: ${_this.syncStatus}, serverId: ${_this.serverId})';
}


}

/// @nodoc
abstract mixin class $FieldDefinitionCopyWith<$Res>  {
  factory $FieldDefinitionCopyWith(FieldDefinition value, $Res Function(FieldDefinition) _then) = _$FieldDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String collectionId, String name, FieldType type, int sortOrder, bool isRequired, bool showInList, bool showInCard, bool searchable, bool sortable, dynamic defaultValue, Map<String, dynamic> options, SyncStatus syncStatus, String? serverId
});




}
/// @nodoc
class _$FieldDefinitionCopyWithImpl<$Res>
    implements $FieldDefinitionCopyWith<$Res> {
  _$FieldDefinitionCopyWithImpl(this._self, this._then);

  final FieldDefinition _self;
  final $Res Function(FieldDefinition) _then;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? collectionId = null,Object? name = null,Object? type = null,Object? sortOrder = null,Object? isRequired = null,Object? showInList = null,Object? showInCard = null,Object? searchable = null,Object? sortable = null,Object? defaultValue = freezed,Object? options = null,Object? syncStatus = null,Object? serverId = freezed,}) {
  return _then(FieldDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collectionId: null == collectionId ? _self.collectionId : collectionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,showInList: null == showInList ? _self.showInList : showInList // ignore: cast_nullable_to_non_nullable
as bool,showInCard: null == showInCard ? _self.showInCard : showInCard // ignore: cast_nullable_to_non_nullable
as bool,searchable: null == searchable ? _self.searchable : searchable // ignore: cast_nullable_to_non_nullable
as bool,sortable: null == sortable ? _self.sortable : sortable // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldDefinition].
extension FieldDefinitionPatterns on FieldDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldDefinition value)  $default,){
final _that = this;
switch (_that) {
case _FieldDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String collectionId,  String name,  FieldType type,  int sortOrder,  bool isRequired,  bool showInList,  bool showInCard,  bool searchable,  bool sortable,  dynamic defaultValue,  Map<String, dynamic> options,  SyncStatus syncStatus,  String? serverId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that.id,_that.collectionId,_that.name,_that.type,_that.sortOrder,_that.isRequired,_that.showInList,_that.showInCard,_that.searchable,_that.sortable,_that.defaultValue,_that.options,_that.syncStatus,_that.serverId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String collectionId,  String name,  FieldType type,  int sortOrder,  bool isRequired,  bool showInList,  bool showInCard,  bool searchable,  bool sortable,  dynamic defaultValue,  Map<String, dynamic> options,  SyncStatus syncStatus,  String? serverId)  $default,) {final _that = this;
switch (_that) {
case _FieldDefinition():
return $default(_that.id,_that.collectionId,_that.name,_that.type,_that.sortOrder,_that.isRequired,_that.showInList,_that.showInCard,_that.searchable,_that.sortable,_that.defaultValue,_that.options,_that.syncStatus,_that.serverId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String collectionId,  String name,  FieldType type,  int sortOrder,  bool isRequired,  bool showInList,  bool showInCard,  bool searchable,  bool sortable,  dynamic defaultValue,  Map<String, dynamic> options,  SyncStatus syncStatus,  String? serverId)?  $default,) {final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that.id,_that.collectionId,_that.name,_that.type,_that.sortOrder,_that.isRequired,_that.showInList,_that.showInCard,_that.searchable,_that.sortable,_that.defaultValue,_that.options,_that.syncStatus,_that.serverId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldDefinition implements FieldDefinition {
  const _FieldDefinition({required this.id, required this.collectionId, required this.name, required this.type, required this.sortOrder, this.isRequired = false, this.showInList = true, this.showInCard = true, this.searchable = true, this.sortable = false, this.defaultValue,  Map<String, dynamic> options = const {}, this.syncStatus = SyncStatus.pending, this.serverId}): _options = options;
  factory _FieldDefinition.fromJson(Map<String, dynamic> json) => _$FieldDefinitionFromJson(json);

@override final  String id;
@override final  String collectionId;
@override final  String name;
@override final  FieldType type;
@override final  int sortOrder;
@override@JsonKey() final  bool isRequired;
@override@JsonKey() final  bool showInList;
@override@JsonKey() final  bool showInCard;
@override@JsonKey() final  bool searchable;
@override@JsonKey() final  bool sortable;
@override final  dynamic defaultValue;
 final  Map<String, dynamic> _options;
@override@JsonKey() Map<String, dynamic> get options {
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_options);
}

@override@JsonKey() final  SyncStatus syncStatus;
@override final  String? serverId;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldDefinitionCopyWith<_FieldDefinition> get copyWith => __$FieldDefinitionCopyWithImpl<_FieldDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.collectionId, collectionId) || other.collectionId == collectionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.showInList, showInList) || other.showInList == showInList)&&(identical(other.showInCard, showInCard) || other.showInCard == showInCard)&&(identical(other.searchable, searchable) || other.searchable == searchable)&&(identical(other.sortable, sortable) || other.sortable == sortable)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.serverId, serverId) || other.serverId == serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,collectionId,name,type,sortOrder,isRequired,showInList,showInCard,searchable,sortable,const DeepCollectionEquality().hash(defaultValue),const DeepCollectionEquality().hash(_options),syncStatus,serverId);
}

@override
String toString() {
    return 'FieldDefinition(id: $id, collectionId: $collectionId, name: $name, type: $type, sortOrder: $sortOrder, isRequired: $isRequired, showInList: $showInList, showInCard: $showInCard, searchable: $searchable, sortable: $sortable, defaultValue: $defaultValue, options: $options, syncStatus: $syncStatus, serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class _$FieldDefinitionCopyWith<$Res> implements $FieldDefinitionCopyWith<$Res> {
  factory _$FieldDefinitionCopyWith(_FieldDefinition value, $Res Function(_FieldDefinition) _then) = __$FieldDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String collectionId, String name, FieldType type, int sortOrder, bool isRequired, bool showInList, bool showInCard, bool searchable, bool sortable, dynamic defaultValue, Map<String, dynamic> options, SyncStatus syncStatus, String? serverId
});




}
/// @nodoc
class __$FieldDefinitionCopyWithImpl<$Res>
    implements _$FieldDefinitionCopyWith<$Res> {
  __$FieldDefinitionCopyWithImpl(this._self, this._then);

  final _FieldDefinition _self;
  final $Res Function(_FieldDefinition) _then;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? collectionId = null,Object? name = null,Object? type = null,Object? sortOrder = null,Object? isRequired = null,Object? showInList = null,Object? showInCard = null,Object? searchable = null,Object? sortable = null,Object? defaultValue = freezed,Object? options = null,Object? syncStatus = null,Object? serverId = freezed,}) {
  return _then(_FieldDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collectionId: null == collectionId ? _self.collectionId : collectionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,showInList: null == showInList ? _self.showInList : showInList // ignore: cast_nullable_to_non_nullable
as bool,showInCard: null == showInCard ? _self.showInCard : showInCard // ignore: cast_nullable_to_non_nullable
as bool,searchable: null == searchable ? _self.searchable : searchable // ignore: cast_nullable_to_non_nullable
as bool,sortable: null == sortable ? _self.sortable : sortable // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
