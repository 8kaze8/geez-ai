// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passport_stamp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PassportStampModel {

 String get id; String get userId; String? get routeId; String get city; String get country; String? get countryCode; String get stampDate; String? get stampImageUrl; DateTime? get createdAt;
/// Create a copy of PassportStampModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassportStampModelCopyWith<PassportStampModel> get copyWith => _$PassportStampModelCopyWithImpl<PassportStampModel>(this as PassportStampModel, _$identity);

  /// Serializes this PassportStampModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PassportStampModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.stampDate, stampDate) || other.stampDate == stampDate)&&(identical(other.stampImageUrl, stampImageUrl) || other.stampImageUrl == stampImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,routeId,city,country,countryCode,stampDate,stampImageUrl,createdAt);

@override
String toString() {
  return 'PassportStampModel(id: $id, userId: $userId, routeId: $routeId, city: $city, country: $country, countryCode: $countryCode, stampDate: $stampDate, stampImageUrl: $stampImageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PassportStampModelCopyWith<$Res>  {
  factory $PassportStampModelCopyWith(PassportStampModel value, $Res Function(PassportStampModel) _then) = _$PassportStampModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? routeId, String city, String country, String? countryCode, String stampDate, String? stampImageUrl, DateTime? createdAt
});




}
/// @nodoc
class _$PassportStampModelCopyWithImpl<$Res>
    implements $PassportStampModelCopyWith<$Res> {
  _$PassportStampModelCopyWithImpl(this._self, this._then);

  final PassportStampModel _self;
  final $Res Function(PassportStampModel) _then;

/// Create a copy of PassportStampModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? routeId = freezed,Object? city = null,Object? country = null,Object? countryCode = freezed,Object? stampDate = null,Object? stampImageUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,stampDate: null == stampDate ? _self.stampDate : stampDate // ignore: cast_nullable_to_non_nullable
as String,stampImageUrl: freezed == stampImageUrl ? _self.stampImageUrl : stampImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PassportStampModel].
extension PassportStampModelPatterns on PassportStampModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PassportStampModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PassportStampModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PassportStampModel value)  $default,){
final _that = this;
switch (_that) {
case _PassportStampModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PassportStampModel value)?  $default,){
final _that = this;
switch (_that) {
case _PassportStampModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? routeId,  String city,  String country,  String? countryCode,  String stampDate,  String? stampImageUrl,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PassportStampModel() when $default != null:
return $default(_that.id,_that.userId,_that.routeId,_that.city,_that.country,_that.countryCode,_that.stampDate,_that.stampImageUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? routeId,  String city,  String country,  String? countryCode,  String stampDate,  String? stampImageUrl,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PassportStampModel():
return $default(_that.id,_that.userId,_that.routeId,_that.city,_that.country,_that.countryCode,_that.stampDate,_that.stampImageUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? routeId,  String city,  String country,  String? countryCode,  String stampDate,  String? stampImageUrl,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PassportStampModel() when $default != null:
return $default(_that.id,_that.userId,_that.routeId,_that.city,_that.country,_that.countryCode,_that.stampDate,_that.stampImageUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PassportStampModel implements PassportStampModel {
  const _PassportStampModel({required this.id, required this.userId, this.routeId, required this.city, required this.country, this.countryCode, required this.stampDate, this.stampImageUrl, this.createdAt});
  factory _PassportStampModel.fromJson(Map<String, dynamic> json) => _$PassportStampModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? routeId;
@override final  String city;
@override final  String country;
@override final  String? countryCode;
@override final  String stampDate;
@override final  String? stampImageUrl;
@override final  DateTime? createdAt;

/// Create a copy of PassportStampModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PassportStampModelCopyWith<_PassportStampModel> get copyWith => __$PassportStampModelCopyWithImpl<_PassportStampModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PassportStampModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PassportStampModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.stampDate, stampDate) || other.stampDate == stampDate)&&(identical(other.stampImageUrl, stampImageUrl) || other.stampImageUrl == stampImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,routeId,city,country,countryCode,stampDate,stampImageUrl,createdAt);

@override
String toString() {
  return 'PassportStampModel(id: $id, userId: $userId, routeId: $routeId, city: $city, country: $country, countryCode: $countryCode, stampDate: $stampDate, stampImageUrl: $stampImageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PassportStampModelCopyWith<$Res> implements $PassportStampModelCopyWith<$Res> {
  factory _$PassportStampModelCopyWith(_PassportStampModel value, $Res Function(_PassportStampModel) _then) = __$PassportStampModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? routeId, String city, String country, String? countryCode, String stampDate, String? stampImageUrl, DateTime? createdAt
});




}
/// @nodoc
class __$PassportStampModelCopyWithImpl<$Res>
    implements _$PassportStampModelCopyWith<$Res> {
  __$PassportStampModelCopyWithImpl(this._self, this._then);

  final _PassportStampModel _self;
  final $Res Function(_PassportStampModel) _then;

/// Create a copy of PassportStampModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? routeId = freezed,Object? city = null,Object? country = null,Object? countryCode = freezed,Object? stampDate = null,Object? stampImageUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_PassportStampModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,stampDate: null == stampDate ? _self.stampDate : stampDate // ignore: cast_nullable_to_non_nullable
as String,stampImageUrl: freezed == stampImageUrl ? _self.stampImageUrl : stampImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
