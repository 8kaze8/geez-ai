// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visited_place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisitedPlaceModel {

 String get id; String get userId; String? get placeId; String get placeName; String get city; String get country; String? get category; int? get userRating;// DATE value from DB — stored as yyyy-MM-dd string
 String? get visitedAt; String? get notes; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of VisitedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitedPlaceModelCopyWith<VisitedPlaceModel> get copyWith => _$VisitedPlaceModelCopyWithImpl<VisitedPlaceModel>(this as VisitedPlaceModel, _$identity);

  /// Serializes this VisitedPlaceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitedPlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.category, category) || other.category == category)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,placeId,placeName,city,country,category,userRating,visitedAt,notes,createdAt,updatedAt);

@override
String toString() {
  return 'VisitedPlaceModel(id: $id, userId: $userId, placeId: $placeId, placeName: $placeName, city: $city, country: $country, category: $category, userRating: $userRating, visitedAt: $visitedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VisitedPlaceModelCopyWith<$Res>  {
  factory $VisitedPlaceModelCopyWith(VisitedPlaceModel value, $Res Function(VisitedPlaceModel) _then) = _$VisitedPlaceModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? placeId, String placeName, String city, String country, String? category, int? userRating, String? visitedAt, String? notes, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$VisitedPlaceModelCopyWithImpl<$Res>
    implements $VisitedPlaceModelCopyWith<$Res> {
  _$VisitedPlaceModelCopyWithImpl(this._self, this._then);

  final VisitedPlaceModel _self;
  final $Res Function(VisitedPlaceModel) _then;

/// Create a copy of VisitedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? placeId = freezed,Object? placeName = null,Object? city = null,Object? country = null,Object? category = freezed,Object? userRating = freezed,Object? visitedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,visitedAt: freezed == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitedPlaceModel].
extension VisitedPlaceModelPatterns on VisitedPlaceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitedPlaceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitedPlaceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitedPlaceModel value)  $default,){
final _that = this;
switch (_that) {
case _VisitedPlaceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitedPlaceModel value)?  $default,){
final _that = this;
switch (_that) {
case _VisitedPlaceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? placeId,  String placeName,  String city,  String country,  String? category,  int? userRating,  String? visitedAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitedPlaceModel() when $default != null:
return $default(_that.id,_that.userId,_that.placeId,_that.placeName,_that.city,_that.country,_that.category,_that.userRating,_that.visitedAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? placeId,  String placeName,  String city,  String country,  String? category,  int? userRating,  String? visitedAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VisitedPlaceModel():
return $default(_that.id,_that.userId,_that.placeId,_that.placeName,_that.city,_that.country,_that.category,_that.userRating,_that.visitedAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? placeId,  String placeName,  String city,  String country,  String? category,  int? userRating,  String? visitedAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VisitedPlaceModel() when $default != null:
return $default(_that.id,_that.userId,_that.placeId,_that.placeName,_that.city,_that.country,_that.category,_that.userRating,_that.visitedAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitedPlaceModel implements VisitedPlaceModel {
  const _VisitedPlaceModel({required this.id, required this.userId, this.placeId, required this.placeName, required this.city, required this.country, this.category, this.userRating, this.visitedAt, this.notes, this.createdAt, this.updatedAt});
  factory _VisitedPlaceModel.fromJson(Map<String, dynamic> json) => _$VisitedPlaceModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? placeId;
@override final  String placeName;
@override final  String city;
@override final  String country;
@override final  String? category;
@override final  int? userRating;
// DATE value from DB — stored as yyyy-MM-dd string
@override final  String? visitedAt;
@override final  String? notes;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of VisitedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitedPlaceModelCopyWith<_VisitedPlaceModel> get copyWith => __$VisitedPlaceModelCopyWithImpl<_VisitedPlaceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitedPlaceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitedPlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.category, category) || other.category == category)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,placeId,placeName,city,country,category,userRating,visitedAt,notes,createdAt,updatedAt);

@override
String toString() {
  return 'VisitedPlaceModel(id: $id, userId: $userId, placeId: $placeId, placeName: $placeName, city: $city, country: $country, category: $category, userRating: $userRating, visitedAt: $visitedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VisitedPlaceModelCopyWith<$Res> implements $VisitedPlaceModelCopyWith<$Res> {
  factory _$VisitedPlaceModelCopyWith(_VisitedPlaceModel value, $Res Function(_VisitedPlaceModel) _then) = __$VisitedPlaceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? placeId, String placeName, String city, String country, String? category, int? userRating, String? visitedAt, String? notes, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$VisitedPlaceModelCopyWithImpl<$Res>
    implements _$VisitedPlaceModelCopyWith<$Res> {
  __$VisitedPlaceModelCopyWithImpl(this._self, this._then);

  final _VisitedPlaceModel _self;
  final $Res Function(_VisitedPlaceModel) _then;

/// Create a copy of VisitedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? placeId = freezed,Object? placeName = null,Object? city = null,Object? country = null,Object? category = freezed,Object? userRating = freezed,Object? visitedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_VisitedPlaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,visitedAt: freezed == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
