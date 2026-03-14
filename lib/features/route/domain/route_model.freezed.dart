// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteModel {

 String get id; String get userId; String get city; String get country; String get title; int get durationDays; String get travelStyle; String get transportMode; String get budgetLevel; String get status; String get startTime; String get language; String? get aiModelUsed; double? get generationCostUsd; DateTime? get completedAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of RouteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteModelCopyWith<RouteModel> get copyWith => _$RouteModelCopyWithImpl<RouteModel>(this as RouteModel, _$identity);

  /// Serializes this RouteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.travelStyle, travelStyle) || other.travelStyle == travelStyle)&&(identical(other.transportMode, transportMode) || other.transportMode == transportMode)&&(identical(other.budgetLevel, budgetLevel) || other.budgetLevel == budgetLevel)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.language, language) || other.language == language)&&(identical(other.aiModelUsed, aiModelUsed) || other.aiModelUsed == aiModelUsed)&&(identical(other.generationCostUsd, generationCostUsd) || other.generationCostUsd == generationCostUsd)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,city,country,title,durationDays,travelStyle,transportMode,budgetLevel,status,startTime,language,aiModelUsed,generationCostUsd,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'RouteModel(id: $id, userId: $userId, city: $city, country: $country, title: $title, durationDays: $durationDays, travelStyle: $travelStyle, transportMode: $transportMode, budgetLevel: $budgetLevel, status: $status, startTime: $startTime, language: $language, aiModelUsed: $aiModelUsed, generationCostUsd: $generationCostUsd, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RouteModelCopyWith<$Res>  {
  factory $RouteModelCopyWith(RouteModel value, $Res Function(RouteModel) _then) = _$RouteModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String city, String country, String title, int durationDays, String travelStyle, String transportMode, String budgetLevel, String status, String startTime, String language, String? aiModelUsed, double? generationCostUsd, DateTime? completedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$RouteModelCopyWithImpl<$Res>
    implements $RouteModelCopyWith<$Res> {
  _$RouteModelCopyWithImpl(this._self, this._then);

  final RouteModel _self;
  final $Res Function(RouteModel) _then;

/// Create a copy of RouteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? city = null,Object? country = null,Object? title = null,Object? durationDays = null,Object? travelStyle = null,Object? transportMode = null,Object? budgetLevel = null,Object? status = null,Object? startTime = null,Object? language = null,Object? aiModelUsed = freezed,Object? generationCostUsd = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,travelStyle: null == travelStyle ? _self.travelStyle : travelStyle // ignore: cast_nullable_to_non_nullable
as String,transportMode: null == transportMode ? _self.transportMode : transportMode // ignore: cast_nullable_to_non_nullable
as String,budgetLevel: null == budgetLevel ? _self.budgetLevel : budgetLevel // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,aiModelUsed: freezed == aiModelUsed ? _self.aiModelUsed : aiModelUsed // ignore: cast_nullable_to_non_nullable
as String?,generationCostUsd: freezed == generationCostUsd ? _self.generationCostUsd : generationCostUsd // ignore: cast_nullable_to_non_nullable
as double?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteModel].
extension RouteModelPatterns on RouteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteModel value)  $default,){
final _that = this;
switch (_that) {
case _RouteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteModel value)?  $default,){
final _that = this;
switch (_that) {
case _RouteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String city,  String country,  String title,  int durationDays,  String travelStyle,  String transportMode,  String budgetLevel,  String status,  String startTime,  String language,  String? aiModelUsed,  double? generationCostUsd,  DateTime? completedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteModel() when $default != null:
return $default(_that.id,_that.userId,_that.city,_that.country,_that.title,_that.durationDays,_that.travelStyle,_that.transportMode,_that.budgetLevel,_that.status,_that.startTime,_that.language,_that.aiModelUsed,_that.generationCostUsd,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String city,  String country,  String title,  int durationDays,  String travelStyle,  String transportMode,  String budgetLevel,  String status,  String startTime,  String language,  String? aiModelUsed,  double? generationCostUsd,  DateTime? completedAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RouteModel():
return $default(_that.id,_that.userId,_that.city,_that.country,_that.title,_that.durationDays,_that.travelStyle,_that.transportMode,_that.budgetLevel,_that.status,_that.startTime,_that.language,_that.aiModelUsed,_that.generationCostUsd,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String city,  String country,  String title,  int durationDays,  String travelStyle,  String transportMode,  String budgetLevel,  String status,  String startTime,  String language,  String? aiModelUsed,  double? generationCostUsd,  DateTime? completedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RouteModel() when $default != null:
return $default(_that.id,_that.userId,_that.city,_that.country,_that.title,_that.durationDays,_that.travelStyle,_that.transportMode,_that.budgetLevel,_that.status,_that.startTime,_that.language,_that.aiModelUsed,_that.generationCostUsd,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteModel implements RouteModel {
  const _RouteModel({required this.id, required this.userId, required this.city, required this.country, required this.title, required this.durationDays, required this.travelStyle, required this.transportMode, required this.budgetLevel, this.status = 'draft', this.startTime = '09:00', this.language = 'tr', this.aiModelUsed, this.generationCostUsd, this.completedAt, this.createdAt, this.updatedAt});
  factory _RouteModel.fromJson(Map<String, dynamic> json) => _$RouteModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String city;
@override final  String country;
@override final  String title;
@override final  int durationDays;
@override final  String travelStyle;
@override final  String transportMode;
@override final  String budgetLevel;
@override@JsonKey() final  String status;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String language;
@override final  String? aiModelUsed;
@override final  double? generationCostUsd;
@override final  DateTime? completedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of RouteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteModelCopyWith<_RouteModel> get copyWith => __$RouteModelCopyWithImpl<_RouteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.travelStyle, travelStyle) || other.travelStyle == travelStyle)&&(identical(other.transportMode, transportMode) || other.transportMode == transportMode)&&(identical(other.budgetLevel, budgetLevel) || other.budgetLevel == budgetLevel)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.language, language) || other.language == language)&&(identical(other.aiModelUsed, aiModelUsed) || other.aiModelUsed == aiModelUsed)&&(identical(other.generationCostUsd, generationCostUsd) || other.generationCostUsd == generationCostUsd)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,city,country,title,durationDays,travelStyle,transportMode,budgetLevel,status,startTime,language,aiModelUsed,generationCostUsd,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'RouteModel(id: $id, userId: $userId, city: $city, country: $country, title: $title, durationDays: $durationDays, travelStyle: $travelStyle, transportMode: $transportMode, budgetLevel: $budgetLevel, status: $status, startTime: $startTime, language: $language, aiModelUsed: $aiModelUsed, generationCostUsd: $generationCostUsd, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RouteModelCopyWith<$Res> implements $RouteModelCopyWith<$Res> {
  factory _$RouteModelCopyWith(_RouteModel value, $Res Function(_RouteModel) _then) = __$RouteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String city, String country, String title, int durationDays, String travelStyle, String transportMode, String budgetLevel, String status, String startTime, String language, String? aiModelUsed, double? generationCostUsd, DateTime? completedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$RouteModelCopyWithImpl<$Res>
    implements _$RouteModelCopyWith<$Res> {
  __$RouteModelCopyWithImpl(this._self, this._then);

  final _RouteModel _self;
  final $Res Function(_RouteModel) _then;

/// Create a copy of RouteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? city = null,Object? country = null,Object? title = null,Object? durationDays = null,Object? travelStyle = null,Object? transportMode = null,Object? budgetLevel = null,Object? status = null,Object? startTime = null,Object? language = null,Object? aiModelUsed = freezed,Object? generationCostUsd = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_RouteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,travelStyle: null == travelStyle ? _self.travelStyle : travelStyle // ignore: cast_nullable_to_non_nullable
as String,transportMode: null == transportMode ? _self.transportMode : transportMode // ignore: cast_nullable_to_non_nullable
as String,budgetLevel: null == budgetLevel ? _self.budgetLevel : budgetLevel // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,aiModelUsed: freezed == aiModelUsed ? _self.aiModelUsed : aiModelUsed // ignore: cast_nullable_to_non_nullable
as String?,generationCostUsd: freezed == generationCostUsd ? _self.generationCostUsd : generationCostUsd // ignore: cast_nullable_to_non_nullable
as double?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
