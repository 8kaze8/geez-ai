// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'travel_persona_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TravelPersonaModel {

 String get id; String get userId; int get foodieLevel; int get historyBuffLevel; int get natureLoverLevel; int get adventureSeekerLevel; int get cultureExplorerLevel; int get discoveryScore; String get explorerTier; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of TravelPersonaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TravelPersonaModelCopyWith<TravelPersonaModel> get copyWith => _$TravelPersonaModelCopyWithImpl<TravelPersonaModel>(this as TravelPersonaModel, _$identity);

  /// Serializes this TravelPersonaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TravelPersonaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.foodieLevel, foodieLevel) || other.foodieLevel == foodieLevel)&&(identical(other.historyBuffLevel, historyBuffLevel) || other.historyBuffLevel == historyBuffLevel)&&(identical(other.natureLoverLevel, natureLoverLevel) || other.natureLoverLevel == natureLoverLevel)&&(identical(other.adventureSeekerLevel, adventureSeekerLevel) || other.adventureSeekerLevel == adventureSeekerLevel)&&(identical(other.cultureExplorerLevel, cultureExplorerLevel) || other.cultureExplorerLevel == cultureExplorerLevel)&&(identical(other.discoveryScore, discoveryScore) || other.discoveryScore == discoveryScore)&&(identical(other.explorerTier, explorerTier) || other.explorerTier == explorerTier)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,foodieLevel,historyBuffLevel,natureLoverLevel,adventureSeekerLevel,cultureExplorerLevel,discoveryScore,explorerTier,createdAt,updatedAt);

@override
String toString() {
  return 'TravelPersonaModel(id: $id, userId: $userId, foodieLevel: $foodieLevel, historyBuffLevel: $historyBuffLevel, natureLoverLevel: $natureLoverLevel, adventureSeekerLevel: $adventureSeekerLevel, cultureExplorerLevel: $cultureExplorerLevel, discoveryScore: $discoveryScore, explorerTier: $explorerTier, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TravelPersonaModelCopyWith<$Res>  {
  factory $TravelPersonaModelCopyWith(TravelPersonaModel value, $Res Function(TravelPersonaModel) _then) = _$TravelPersonaModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int foodieLevel, int historyBuffLevel, int natureLoverLevel, int adventureSeekerLevel, int cultureExplorerLevel, int discoveryScore, String explorerTier, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$TravelPersonaModelCopyWithImpl<$Res>
    implements $TravelPersonaModelCopyWith<$Res> {
  _$TravelPersonaModelCopyWithImpl(this._self, this._then);

  final TravelPersonaModel _self;
  final $Res Function(TravelPersonaModel) _then;

/// Create a copy of TravelPersonaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? foodieLevel = null,Object? historyBuffLevel = null,Object? natureLoverLevel = null,Object? adventureSeekerLevel = null,Object? cultureExplorerLevel = null,Object? discoveryScore = null,Object? explorerTier = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,foodieLevel: null == foodieLevel ? _self.foodieLevel : foodieLevel // ignore: cast_nullable_to_non_nullable
as int,historyBuffLevel: null == historyBuffLevel ? _self.historyBuffLevel : historyBuffLevel // ignore: cast_nullable_to_non_nullable
as int,natureLoverLevel: null == natureLoverLevel ? _self.natureLoverLevel : natureLoverLevel // ignore: cast_nullable_to_non_nullable
as int,adventureSeekerLevel: null == adventureSeekerLevel ? _self.adventureSeekerLevel : adventureSeekerLevel // ignore: cast_nullable_to_non_nullable
as int,cultureExplorerLevel: null == cultureExplorerLevel ? _self.cultureExplorerLevel : cultureExplorerLevel // ignore: cast_nullable_to_non_nullable
as int,discoveryScore: null == discoveryScore ? _self.discoveryScore : discoveryScore // ignore: cast_nullable_to_non_nullable
as int,explorerTier: null == explorerTier ? _self.explorerTier : explorerTier // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TravelPersonaModel].
extension TravelPersonaModelPatterns on TravelPersonaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TravelPersonaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TravelPersonaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TravelPersonaModel value)  $default,){
final _that = this;
switch (_that) {
case _TravelPersonaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TravelPersonaModel value)?  $default,){
final _that = this;
switch (_that) {
case _TravelPersonaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int foodieLevel,  int historyBuffLevel,  int natureLoverLevel,  int adventureSeekerLevel,  int cultureExplorerLevel,  int discoveryScore,  String explorerTier,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TravelPersonaModel() when $default != null:
return $default(_that.id,_that.userId,_that.foodieLevel,_that.historyBuffLevel,_that.natureLoverLevel,_that.adventureSeekerLevel,_that.cultureExplorerLevel,_that.discoveryScore,_that.explorerTier,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int foodieLevel,  int historyBuffLevel,  int natureLoverLevel,  int adventureSeekerLevel,  int cultureExplorerLevel,  int discoveryScore,  String explorerTier,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TravelPersonaModel():
return $default(_that.id,_that.userId,_that.foodieLevel,_that.historyBuffLevel,_that.natureLoverLevel,_that.adventureSeekerLevel,_that.cultureExplorerLevel,_that.discoveryScore,_that.explorerTier,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int foodieLevel,  int historyBuffLevel,  int natureLoverLevel,  int adventureSeekerLevel,  int cultureExplorerLevel,  int discoveryScore,  String explorerTier,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TravelPersonaModel() when $default != null:
return $default(_that.id,_that.userId,_that.foodieLevel,_that.historyBuffLevel,_that.natureLoverLevel,_that.adventureSeekerLevel,_that.cultureExplorerLevel,_that.discoveryScore,_that.explorerTier,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TravelPersonaModel implements TravelPersonaModel {
  const _TravelPersonaModel({required this.id, required this.userId, this.foodieLevel = 1, this.historyBuffLevel = 1, this.natureLoverLevel = 1, this.adventureSeekerLevel = 1, this.cultureExplorerLevel = 1, this.discoveryScore = 0, this.explorerTier = 'tourist', this.createdAt, this.updatedAt});
  factory _TravelPersonaModel.fromJson(Map<String, dynamic> json) => _$TravelPersonaModelFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  int foodieLevel;
@override@JsonKey() final  int historyBuffLevel;
@override@JsonKey() final  int natureLoverLevel;
@override@JsonKey() final  int adventureSeekerLevel;
@override@JsonKey() final  int cultureExplorerLevel;
@override@JsonKey() final  int discoveryScore;
@override@JsonKey() final  String explorerTier;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of TravelPersonaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TravelPersonaModelCopyWith<_TravelPersonaModel> get copyWith => __$TravelPersonaModelCopyWithImpl<_TravelPersonaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TravelPersonaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TravelPersonaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.foodieLevel, foodieLevel) || other.foodieLevel == foodieLevel)&&(identical(other.historyBuffLevel, historyBuffLevel) || other.historyBuffLevel == historyBuffLevel)&&(identical(other.natureLoverLevel, natureLoverLevel) || other.natureLoverLevel == natureLoverLevel)&&(identical(other.adventureSeekerLevel, adventureSeekerLevel) || other.adventureSeekerLevel == adventureSeekerLevel)&&(identical(other.cultureExplorerLevel, cultureExplorerLevel) || other.cultureExplorerLevel == cultureExplorerLevel)&&(identical(other.discoveryScore, discoveryScore) || other.discoveryScore == discoveryScore)&&(identical(other.explorerTier, explorerTier) || other.explorerTier == explorerTier)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,foodieLevel,historyBuffLevel,natureLoverLevel,adventureSeekerLevel,cultureExplorerLevel,discoveryScore,explorerTier,createdAt,updatedAt);

@override
String toString() {
  return 'TravelPersonaModel(id: $id, userId: $userId, foodieLevel: $foodieLevel, historyBuffLevel: $historyBuffLevel, natureLoverLevel: $natureLoverLevel, adventureSeekerLevel: $adventureSeekerLevel, cultureExplorerLevel: $cultureExplorerLevel, discoveryScore: $discoveryScore, explorerTier: $explorerTier, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TravelPersonaModelCopyWith<$Res> implements $TravelPersonaModelCopyWith<$Res> {
  factory _$TravelPersonaModelCopyWith(_TravelPersonaModel value, $Res Function(_TravelPersonaModel) _then) = __$TravelPersonaModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int foodieLevel, int historyBuffLevel, int natureLoverLevel, int adventureSeekerLevel, int cultureExplorerLevel, int discoveryScore, String explorerTier, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$TravelPersonaModelCopyWithImpl<$Res>
    implements _$TravelPersonaModelCopyWith<$Res> {
  __$TravelPersonaModelCopyWithImpl(this._self, this._then);

  final _TravelPersonaModel _self;
  final $Res Function(_TravelPersonaModel) _then;

/// Create a copy of TravelPersonaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? foodieLevel = null,Object? historyBuffLevel = null,Object? natureLoverLevel = null,Object? adventureSeekerLevel = null,Object? cultureExplorerLevel = null,Object? discoveryScore = null,Object? explorerTier = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TravelPersonaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,foodieLevel: null == foodieLevel ? _self.foodieLevel : foodieLevel // ignore: cast_nullable_to_non_nullable
as int,historyBuffLevel: null == historyBuffLevel ? _self.historyBuffLevel : historyBuffLevel // ignore: cast_nullable_to_non_nullable
as int,natureLoverLevel: null == natureLoverLevel ? _self.natureLoverLevel : natureLoverLevel // ignore: cast_nullable_to_non_nullable
as int,adventureSeekerLevel: null == adventureSeekerLevel ? _self.adventureSeekerLevel : adventureSeekerLevel // ignore: cast_nullable_to_non_nullable
as int,cultureExplorerLevel: null == cultureExplorerLevel ? _self.cultureExplorerLevel : cultureExplorerLevel // ignore: cast_nullable_to_non_nullable
as int,discoveryScore: null == discoveryScore ? _self.discoveryScore : discoveryScore // ignore: cast_nullable_to_non_nullable
as int,explorerTier: null == explorerTier ? _self.explorerTier : explorerTier // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
