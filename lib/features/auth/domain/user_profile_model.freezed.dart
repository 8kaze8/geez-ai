// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileModel {

 String get id; String get userId; String? get ageGroup; String? get travelCompanion; String? get defaultBudget; List<String> get preferredActivities; Map<String, dynamic> get foodPreferences; String get pacePreference; bool get morningPerson; String get crowdTolerance; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.travelCompanion, travelCompanion) || other.travelCompanion == travelCompanion)&&(identical(other.defaultBudget, defaultBudget) || other.defaultBudget == defaultBudget)&&const DeepCollectionEquality().equals(other.preferredActivities, preferredActivities)&&const DeepCollectionEquality().equals(other.foodPreferences, foodPreferences)&&(identical(other.pacePreference, pacePreference) || other.pacePreference == pacePreference)&&(identical(other.morningPerson, morningPerson) || other.morningPerson == morningPerson)&&(identical(other.crowdTolerance, crowdTolerance) || other.crowdTolerance == crowdTolerance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,ageGroup,travelCompanion,defaultBudget,const DeepCollectionEquality().hash(preferredActivities),const DeepCollectionEquality().hash(foodPreferences),pacePreference,morningPerson,crowdTolerance,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfileModel(id: $id, userId: $userId, ageGroup: $ageGroup, travelCompanion: $travelCompanion, defaultBudget: $defaultBudget, preferredActivities: $preferredActivities, foodPreferences: $foodPreferences, pacePreference: $pacePreference, morningPerson: $morningPerson, crowdTolerance: $crowdTolerance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? ageGroup, String? travelCompanion, String? defaultBudget, List<String> preferredActivities, Map<String, dynamic> foodPreferences, String pacePreference, bool morningPerson, String crowdTolerance, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? ageGroup = freezed,Object? travelCompanion = freezed,Object? defaultBudget = freezed,Object? preferredActivities = null,Object? foodPreferences = null,Object? pacePreference = null,Object? morningPerson = null,Object? crowdTolerance = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String?,travelCompanion: freezed == travelCompanion ? _self.travelCompanion : travelCompanion // ignore: cast_nullable_to_non_nullable
as String?,defaultBudget: freezed == defaultBudget ? _self.defaultBudget : defaultBudget // ignore: cast_nullable_to_non_nullable
as String?,preferredActivities: null == preferredActivities ? _self.preferredActivities : preferredActivities // ignore: cast_nullable_to_non_nullable
as List<String>,foodPreferences: null == foodPreferences ? _self.foodPreferences : foodPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,pacePreference: null == pacePreference ? _self.pacePreference : pacePreference // ignore: cast_nullable_to_non_nullable
as String,morningPerson: null == morningPerson ? _self.morningPerson : morningPerson // ignore: cast_nullable_to_non_nullable
as bool,crowdTolerance: null == crowdTolerance ? _self.crowdTolerance : crowdTolerance // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? ageGroup,  String? travelCompanion,  String? defaultBudget,  List<String> preferredActivities,  Map<String, dynamic> foodPreferences,  String pacePreference,  bool morningPerson,  String crowdTolerance,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.userId,_that.ageGroup,_that.travelCompanion,_that.defaultBudget,_that.preferredActivities,_that.foodPreferences,_that.pacePreference,_that.morningPerson,_that.crowdTolerance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? ageGroup,  String? travelCompanion,  String? defaultBudget,  List<String> preferredActivities,  Map<String, dynamic> foodPreferences,  String pacePreference,  bool morningPerson,  String crowdTolerance,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.id,_that.userId,_that.ageGroup,_that.travelCompanion,_that.defaultBudget,_that.preferredActivities,_that.foodPreferences,_that.pacePreference,_that.morningPerson,_that.crowdTolerance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? ageGroup,  String? travelCompanion,  String? defaultBudget,  List<String> preferredActivities,  Map<String, dynamic> foodPreferences,  String pacePreference,  bool morningPerson,  String crowdTolerance,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.userId,_that.ageGroup,_that.travelCompanion,_that.defaultBudget,_that.preferredActivities,_that.foodPreferences,_that.pacePreference,_that.morningPerson,_that.crowdTolerance,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileModel implements UserProfileModel {
  const _UserProfileModel({required this.id, required this.userId, this.ageGroup, this.travelCompanion, this.defaultBudget, final  List<String> preferredActivities = const <String>[], final  Map<String, dynamic> foodPreferences = const <String, dynamic>{}, this.pacePreference = 'normal', this.morningPerson = true, this.crowdTolerance = 'medium', this.createdAt, this.updatedAt}): _preferredActivities = preferredActivities,_foodPreferences = foodPreferences;
  factory _UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? ageGroup;
@override final  String? travelCompanion;
@override final  String? defaultBudget;
 final  List<String> _preferredActivities;
@override@JsonKey() List<String> get preferredActivities {
  if (_preferredActivities is EqualUnmodifiableListView) return _preferredActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferredActivities);
}

 final  Map<String, dynamic> _foodPreferences;
@override@JsonKey() Map<String, dynamic> get foodPreferences {
  if (_foodPreferences is EqualUnmodifiableMapView) return _foodPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_foodPreferences);
}

@override@JsonKey() final  String pacePreference;
@override@JsonKey() final  bool morningPerson;
@override@JsonKey() final  String crowdTolerance;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.travelCompanion, travelCompanion) || other.travelCompanion == travelCompanion)&&(identical(other.defaultBudget, defaultBudget) || other.defaultBudget == defaultBudget)&&const DeepCollectionEquality().equals(other._preferredActivities, _preferredActivities)&&const DeepCollectionEquality().equals(other._foodPreferences, _foodPreferences)&&(identical(other.pacePreference, pacePreference) || other.pacePreference == pacePreference)&&(identical(other.morningPerson, morningPerson) || other.morningPerson == morningPerson)&&(identical(other.crowdTolerance, crowdTolerance) || other.crowdTolerance == crowdTolerance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,ageGroup,travelCompanion,defaultBudget,const DeepCollectionEquality().hash(_preferredActivities),const DeepCollectionEquality().hash(_foodPreferences),pacePreference,morningPerson,crowdTolerance,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfileModel(id: $id, userId: $userId, ageGroup: $ageGroup, travelCompanion: $travelCompanion, defaultBudget: $defaultBudget, preferredActivities: $preferredActivities, foodPreferences: $foodPreferences, pacePreference: $pacePreference, morningPerson: $morningPerson, crowdTolerance: $crowdTolerance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? ageGroup, String? travelCompanion, String? defaultBudget, List<String> preferredActivities, Map<String, dynamic> foodPreferences, String pacePreference, bool morningPerson, String crowdTolerance, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? ageGroup = freezed,Object? travelCompanion = freezed,Object? defaultBudget = freezed,Object? preferredActivities = null,Object? foodPreferences = null,Object? pacePreference = null,Object? morningPerson = null,Object? crowdTolerance = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String?,travelCompanion: freezed == travelCompanion ? _self.travelCompanion : travelCompanion // ignore: cast_nullable_to_non_nullable
as String?,defaultBudget: freezed == defaultBudget ? _self.defaultBudget : defaultBudget // ignore: cast_nullable_to_non_nullable
as String?,preferredActivities: null == preferredActivities ? _self._preferredActivities : preferredActivities // ignore: cast_nullable_to_non_nullable
as List<String>,foodPreferences: null == foodPreferences ? _self._foodPreferences : foodPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,pacePreference: null == pacePreference ? _self.pacePreference : pacePreference // ignore: cast_nullable_to_non_nullable
as String,morningPerson: null == morningPerson ? _self.morningPerson : morningPerson // ignore: cast_nullable_to_non_nullable
as bool,crowdTolerance: null == crowdTolerance ? _self.crowdTolerance : crowdTolerance // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
