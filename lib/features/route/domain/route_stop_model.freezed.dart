// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_stop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteStopModel {

 String get id; String get routeId; int get stopOrder; int get dayNumber; String get placeName; String? get placeId; double? get latitude; double? get longitude; String? get category; String? get description; String? get insiderTip; String? get funFact; String? get bestTime; String? get warnings; String? get reviewSummary; double? get googleRating; int? get reviewCount; int? get estimatedDurationMin; String? get entryFeeText; double? get entryFeeAmount; String get entryFeeCurrency; int? get travelFromPreviousMin; String? get travelModeFromPrevious; int get discoveryPoints;// TIME values from DB — stored as HH:mm string
 String? get suggestedStartTime; String? get suggestedEndTime; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of RouteStopModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStopModelCopyWith<RouteStopModel> get copyWith => _$RouteStopModelCopyWithImpl<RouteStopModel>(this as RouteStopModel, _$identity);

  /// Serializes this RouteStopModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStopModel&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.stopOrder, stopOrder) || other.stopOrder == stopOrder)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.insiderTip, insiderTip) || other.insiderTip == insiderTip)&&(identical(other.funFact, funFact) || other.funFact == funFact)&&(identical(other.bestTime, bestTime) || other.bestTime == bestTime)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.reviewSummary, reviewSummary) || other.reviewSummary == reviewSummary)&&(identical(other.googleRating, googleRating) || other.googleRating == googleRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.estimatedDurationMin, estimatedDurationMin) || other.estimatedDurationMin == estimatedDurationMin)&&(identical(other.entryFeeText, entryFeeText) || other.entryFeeText == entryFeeText)&&(identical(other.entryFeeAmount, entryFeeAmount) || other.entryFeeAmount == entryFeeAmount)&&(identical(other.entryFeeCurrency, entryFeeCurrency) || other.entryFeeCurrency == entryFeeCurrency)&&(identical(other.travelFromPreviousMin, travelFromPreviousMin) || other.travelFromPreviousMin == travelFromPreviousMin)&&(identical(other.travelModeFromPrevious, travelModeFromPrevious) || other.travelModeFromPrevious == travelModeFromPrevious)&&(identical(other.discoveryPoints, discoveryPoints) || other.discoveryPoints == discoveryPoints)&&(identical(other.suggestedStartTime, suggestedStartTime) || other.suggestedStartTime == suggestedStartTime)&&(identical(other.suggestedEndTime, suggestedEndTime) || other.suggestedEndTime == suggestedEndTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,routeId,stopOrder,dayNumber,placeName,placeId,latitude,longitude,category,description,insiderTip,funFact,bestTime,warnings,reviewSummary,googleRating,reviewCount,estimatedDurationMin,entryFeeText,entryFeeAmount,entryFeeCurrency,travelFromPreviousMin,travelModeFromPrevious,discoveryPoints,suggestedStartTime,suggestedEndTime,createdAt,updatedAt]);

@override
String toString() {
  return 'RouteStopModel(id: $id, routeId: $routeId, stopOrder: $stopOrder, dayNumber: $dayNumber, placeName: $placeName, placeId: $placeId, latitude: $latitude, longitude: $longitude, category: $category, description: $description, insiderTip: $insiderTip, funFact: $funFact, bestTime: $bestTime, warnings: $warnings, reviewSummary: $reviewSummary, googleRating: $googleRating, reviewCount: $reviewCount, estimatedDurationMin: $estimatedDurationMin, entryFeeText: $entryFeeText, entryFeeAmount: $entryFeeAmount, entryFeeCurrency: $entryFeeCurrency, travelFromPreviousMin: $travelFromPreviousMin, travelModeFromPrevious: $travelModeFromPrevious, discoveryPoints: $discoveryPoints, suggestedStartTime: $suggestedStartTime, suggestedEndTime: $suggestedEndTime, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RouteStopModelCopyWith<$Res>  {
  factory $RouteStopModelCopyWith(RouteStopModel value, $Res Function(RouteStopModel) _then) = _$RouteStopModelCopyWithImpl;
@useResult
$Res call({
 String id, String routeId, int stopOrder, int dayNumber, String placeName, String? placeId, double? latitude, double? longitude, String? category, String? description, String? insiderTip, String? funFact, String? bestTime, String? warnings, String? reviewSummary, double? googleRating, int? reviewCount, int? estimatedDurationMin, String? entryFeeText, double? entryFeeAmount, String entryFeeCurrency, int? travelFromPreviousMin, String? travelModeFromPrevious, int discoveryPoints, String? suggestedStartTime, String? suggestedEndTime, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$RouteStopModelCopyWithImpl<$Res>
    implements $RouteStopModelCopyWith<$Res> {
  _$RouteStopModelCopyWithImpl(this._self, this._then);

  final RouteStopModel _self;
  final $Res Function(RouteStopModel) _then;

/// Create a copy of RouteStopModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routeId = null,Object? stopOrder = null,Object? dayNumber = null,Object? placeName = null,Object? placeId = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? category = freezed,Object? description = freezed,Object? insiderTip = freezed,Object? funFact = freezed,Object? bestTime = freezed,Object? warnings = freezed,Object? reviewSummary = freezed,Object? googleRating = freezed,Object? reviewCount = freezed,Object? estimatedDurationMin = freezed,Object? entryFeeText = freezed,Object? entryFeeAmount = freezed,Object? entryFeeCurrency = null,Object? travelFromPreviousMin = freezed,Object? travelModeFromPrevious = freezed,Object? discoveryPoints = null,Object? suggestedStartTime = freezed,Object? suggestedEndTime = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,stopOrder: null == stopOrder ? _self.stopOrder : stopOrder // ignore: cast_nullable_to_non_nullable
as int,dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,insiderTip: freezed == insiderTip ? _self.insiderTip : insiderTip // ignore: cast_nullable_to_non_nullable
as String?,funFact: freezed == funFact ? _self.funFact : funFact // ignore: cast_nullable_to_non_nullable
as String?,bestTime: freezed == bestTime ? _self.bestTime : bestTime // ignore: cast_nullable_to_non_nullable
as String?,warnings: freezed == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String?,reviewSummary: freezed == reviewSummary ? _self.reviewSummary : reviewSummary // ignore: cast_nullable_to_non_nullable
as String?,googleRating: freezed == googleRating ? _self.googleRating : googleRating // ignore: cast_nullable_to_non_nullable
as double?,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,estimatedDurationMin: freezed == estimatedDurationMin ? _self.estimatedDurationMin : estimatedDurationMin // ignore: cast_nullable_to_non_nullable
as int?,entryFeeText: freezed == entryFeeText ? _self.entryFeeText : entryFeeText // ignore: cast_nullable_to_non_nullable
as String?,entryFeeAmount: freezed == entryFeeAmount ? _self.entryFeeAmount : entryFeeAmount // ignore: cast_nullable_to_non_nullable
as double?,entryFeeCurrency: null == entryFeeCurrency ? _self.entryFeeCurrency : entryFeeCurrency // ignore: cast_nullable_to_non_nullable
as String,travelFromPreviousMin: freezed == travelFromPreviousMin ? _self.travelFromPreviousMin : travelFromPreviousMin // ignore: cast_nullable_to_non_nullable
as int?,travelModeFromPrevious: freezed == travelModeFromPrevious ? _self.travelModeFromPrevious : travelModeFromPrevious // ignore: cast_nullable_to_non_nullable
as String?,discoveryPoints: null == discoveryPoints ? _self.discoveryPoints : discoveryPoints // ignore: cast_nullable_to_non_nullable
as int,suggestedStartTime: freezed == suggestedStartTime ? _self.suggestedStartTime : suggestedStartTime // ignore: cast_nullable_to_non_nullable
as String?,suggestedEndTime: freezed == suggestedEndTime ? _self.suggestedEndTime : suggestedEndTime // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteStopModel].
extension RouteStopModelPatterns on RouteStopModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStopModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStopModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStopModel value)  $default,){
final _that = this;
switch (_that) {
case _RouteStopModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStopModel value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStopModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routeId,  int stopOrder,  int dayNumber,  String placeName,  String? placeId,  double? latitude,  double? longitude,  String? category,  String? description,  String? insiderTip,  String? funFact,  String? bestTime,  String? warnings,  String? reviewSummary,  double? googleRating,  int? reviewCount,  int? estimatedDurationMin,  String? entryFeeText,  double? entryFeeAmount,  String entryFeeCurrency,  int? travelFromPreviousMin,  String? travelModeFromPrevious,  int discoveryPoints,  String? suggestedStartTime,  String? suggestedEndTime,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStopModel() when $default != null:
return $default(_that.id,_that.routeId,_that.stopOrder,_that.dayNumber,_that.placeName,_that.placeId,_that.latitude,_that.longitude,_that.category,_that.description,_that.insiderTip,_that.funFact,_that.bestTime,_that.warnings,_that.reviewSummary,_that.googleRating,_that.reviewCount,_that.estimatedDurationMin,_that.entryFeeText,_that.entryFeeAmount,_that.entryFeeCurrency,_that.travelFromPreviousMin,_that.travelModeFromPrevious,_that.discoveryPoints,_that.suggestedStartTime,_that.suggestedEndTime,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routeId,  int stopOrder,  int dayNumber,  String placeName,  String? placeId,  double? latitude,  double? longitude,  String? category,  String? description,  String? insiderTip,  String? funFact,  String? bestTime,  String? warnings,  String? reviewSummary,  double? googleRating,  int? reviewCount,  int? estimatedDurationMin,  String? entryFeeText,  double? entryFeeAmount,  String entryFeeCurrency,  int? travelFromPreviousMin,  String? travelModeFromPrevious,  int discoveryPoints,  String? suggestedStartTime,  String? suggestedEndTime,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RouteStopModel():
return $default(_that.id,_that.routeId,_that.stopOrder,_that.dayNumber,_that.placeName,_that.placeId,_that.latitude,_that.longitude,_that.category,_that.description,_that.insiderTip,_that.funFact,_that.bestTime,_that.warnings,_that.reviewSummary,_that.googleRating,_that.reviewCount,_that.estimatedDurationMin,_that.entryFeeText,_that.entryFeeAmount,_that.entryFeeCurrency,_that.travelFromPreviousMin,_that.travelModeFromPrevious,_that.discoveryPoints,_that.suggestedStartTime,_that.suggestedEndTime,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routeId,  int stopOrder,  int dayNumber,  String placeName,  String? placeId,  double? latitude,  double? longitude,  String? category,  String? description,  String? insiderTip,  String? funFact,  String? bestTime,  String? warnings,  String? reviewSummary,  double? googleRating,  int? reviewCount,  int? estimatedDurationMin,  String? entryFeeText,  double? entryFeeAmount,  String entryFeeCurrency,  int? travelFromPreviousMin,  String? travelModeFromPrevious,  int discoveryPoints,  String? suggestedStartTime,  String? suggestedEndTime,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RouteStopModel() when $default != null:
return $default(_that.id,_that.routeId,_that.stopOrder,_that.dayNumber,_that.placeName,_that.placeId,_that.latitude,_that.longitude,_that.category,_that.description,_that.insiderTip,_that.funFact,_that.bestTime,_that.warnings,_that.reviewSummary,_that.googleRating,_that.reviewCount,_that.estimatedDurationMin,_that.entryFeeText,_that.entryFeeAmount,_that.entryFeeCurrency,_that.travelFromPreviousMin,_that.travelModeFromPrevious,_that.discoveryPoints,_that.suggestedStartTime,_that.suggestedEndTime,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteStopModel implements RouteStopModel {
  const _RouteStopModel({required this.id, required this.routeId, required this.stopOrder, required this.dayNumber, required this.placeName, this.placeId, this.latitude, this.longitude, this.category, this.description, this.insiderTip, this.funFact, this.bestTime, this.warnings, this.reviewSummary, this.googleRating, this.reviewCount, this.estimatedDurationMin, this.entryFeeText, this.entryFeeAmount, this.entryFeeCurrency = 'TRY', this.travelFromPreviousMin, this.travelModeFromPrevious, this.discoveryPoints = 0, this.suggestedStartTime, this.suggestedEndTime, this.createdAt, this.updatedAt});
  factory _RouteStopModel.fromJson(Map<String, dynamic> json) => _$RouteStopModelFromJson(json);

@override final  String id;
@override final  String routeId;
@override final  int stopOrder;
@override final  int dayNumber;
@override final  String placeName;
@override final  String? placeId;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? category;
@override final  String? description;
@override final  String? insiderTip;
@override final  String? funFact;
@override final  String? bestTime;
@override final  String? warnings;
@override final  String? reviewSummary;
@override final  double? googleRating;
@override final  int? reviewCount;
@override final  int? estimatedDurationMin;
@override final  String? entryFeeText;
@override final  double? entryFeeAmount;
@override@JsonKey() final  String entryFeeCurrency;
@override final  int? travelFromPreviousMin;
@override final  String? travelModeFromPrevious;
@override@JsonKey() final  int discoveryPoints;
// TIME values from DB — stored as HH:mm string
@override final  String? suggestedStartTime;
@override final  String? suggestedEndTime;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of RouteStopModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStopModelCopyWith<_RouteStopModel> get copyWith => __$RouteStopModelCopyWithImpl<_RouteStopModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteStopModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStopModel&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.stopOrder, stopOrder) || other.stopOrder == stopOrder)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.insiderTip, insiderTip) || other.insiderTip == insiderTip)&&(identical(other.funFact, funFact) || other.funFact == funFact)&&(identical(other.bestTime, bestTime) || other.bestTime == bestTime)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.reviewSummary, reviewSummary) || other.reviewSummary == reviewSummary)&&(identical(other.googleRating, googleRating) || other.googleRating == googleRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.estimatedDurationMin, estimatedDurationMin) || other.estimatedDurationMin == estimatedDurationMin)&&(identical(other.entryFeeText, entryFeeText) || other.entryFeeText == entryFeeText)&&(identical(other.entryFeeAmount, entryFeeAmount) || other.entryFeeAmount == entryFeeAmount)&&(identical(other.entryFeeCurrency, entryFeeCurrency) || other.entryFeeCurrency == entryFeeCurrency)&&(identical(other.travelFromPreviousMin, travelFromPreviousMin) || other.travelFromPreviousMin == travelFromPreviousMin)&&(identical(other.travelModeFromPrevious, travelModeFromPrevious) || other.travelModeFromPrevious == travelModeFromPrevious)&&(identical(other.discoveryPoints, discoveryPoints) || other.discoveryPoints == discoveryPoints)&&(identical(other.suggestedStartTime, suggestedStartTime) || other.suggestedStartTime == suggestedStartTime)&&(identical(other.suggestedEndTime, suggestedEndTime) || other.suggestedEndTime == suggestedEndTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,routeId,stopOrder,dayNumber,placeName,placeId,latitude,longitude,category,description,insiderTip,funFact,bestTime,warnings,reviewSummary,googleRating,reviewCount,estimatedDurationMin,entryFeeText,entryFeeAmount,entryFeeCurrency,travelFromPreviousMin,travelModeFromPrevious,discoveryPoints,suggestedStartTime,suggestedEndTime,createdAt,updatedAt]);

@override
String toString() {
  return 'RouteStopModel(id: $id, routeId: $routeId, stopOrder: $stopOrder, dayNumber: $dayNumber, placeName: $placeName, placeId: $placeId, latitude: $latitude, longitude: $longitude, category: $category, description: $description, insiderTip: $insiderTip, funFact: $funFact, bestTime: $bestTime, warnings: $warnings, reviewSummary: $reviewSummary, googleRating: $googleRating, reviewCount: $reviewCount, estimatedDurationMin: $estimatedDurationMin, entryFeeText: $entryFeeText, entryFeeAmount: $entryFeeAmount, entryFeeCurrency: $entryFeeCurrency, travelFromPreviousMin: $travelFromPreviousMin, travelModeFromPrevious: $travelModeFromPrevious, discoveryPoints: $discoveryPoints, suggestedStartTime: $suggestedStartTime, suggestedEndTime: $suggestedEndTime, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RouteStopModelCopyWith<$Res> implements $RouteStopModelCopyWith<$Res> {
  factory _$RouteStopModelCopyWith(_RouteStopModel value, $Res Function(_RouteStopModel) _then) = __$RouteStopModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String routeId, int stopOrder, int dayNumber, String placeName, String? placeId, double? latitude, double? longitude, String? category, String? description, String? insiderTip, String? funFact, String? bestTime, String? warnings, String? reviewSummary, double? googleRating, int? reviewCount, int? estimatedDurationMin, String? entryFeeText, double? entryFeeAmount, String entryFeeCurrency, int? travelFromPreviousMin, String? travelModeFromPrevious, int discoveryPoints, String? suggestedStartTime, String? suggestedEndTime, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$RouteStopModelCopyWithImpl<$Res>
    implements _$RouteStopModelCopyWith<$Res> {
  __$RouteStopModelCopyWithImpl(this._self, this._then);

  final _RouteStopModel _self;
  final $Res Function(_RouteStopModel) _then;

/// Create a copy of RouteStopModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routeId = null,Object? stopOrder = null,Object? dayNumber = null,Object? placeName = null,Object? placeId = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? category = freezed,Object? description = freezed,Object? insiderTip = freezed,Object? funFact = freezed,Object? bestTime = freezed,Object? warnings = freezed,Object? reviewSummary = freezed,Object? googleRating = freezed,Object? reviewCount = freezed,Object? estimatedDurationMin = freezed,Object? entryFeeText = freezed,Object? entryFeeAmount = freezed,Object? entryFeeCurrency = null,Object? travelFromPreviousMin = freezed,Object? travelModeFromPrevious = freezed,Object? discoveryPoints = null,Object? suggestedStartTime = freezed,Object? suggestedEndTime = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_RouteStopModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,stopOrder: null == stopOrder ? _self.stopOrder : stopOrder // ignore: cast_nullable_to_non_nullable
as int,dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,insiderTip: freezed == insiderTip ? _self.insiderTip : insiderTip // ignore: cast_nullable_to_non_nullable
as String?,funFact: freezed == funFact ? _self.funFact : funFact // ignore: cast_nullable_to_non_nullable
as String?,bestTime: freezed == bestTime ? _self.bestTime : bestTime // ignore: cast_nullable_to_non_nullable
as String?,warnings: freezed == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String?,reviewSummary: freezed == reviewSummary ? _self.reviewSummary : reviewSummary // ignore: cast_nullable_to_non_nullable
as String?,googleRating: freezed == googleRating ? _self.googleRating : googleRating // ignore: cast_nullable_to_non_nullable
as double?,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,estimatedDurationMin: freezed == estimatedDurationMin ? _self.estimatedDurationMin : estimatedDurationMin // ignore: cast_nullable_to_non_nullable
as int?,entryFeeText: freezed == entryFeeText ? _self.entryFeeText : entryFeeText // ignore: cast_nullable_to_non_nullable
as String?,entryFeeAmount: freezed == entryFeeAmount ? _self.entryFeeAmount : entryFeeAmount // ignore: cast_nullable_to_non_nullable
as double?,entryFeeCurrency: null == entryFeeCurrency ? _self.entryFeeCurrency : entryFeeCurrency // ignore: cast_nullable_to_non_nullable
as String,travelFromPreviousMin: freezed == travelFromPreviousMin ? _self.travelFromPreviousMin : travelFromPreviousMin // ignore: cast_nullable_to_non_nullable
as int?,travelModeFromPrevious: freezed == travelModeFromPrevious ? _self.travelModeFromPrevious : travelModeFromPrevious // ignore: cast_nullable_to_non_nullable
as String?,discoveryPoints: null == discoveryPoints ? _self.discoveryPoints : discoveryPoints // ignore: cast_nullable_to_non_nullable
as int,suggestedStartTime: freezed == suggestedStartTime ? _self.suggestedStartTime : suggestedStartTime // ignore: cast_nullable_to_non_nullable
as String?,suggestedEndTime: freezed == suggestedEndTime ? _self.suggestedEndTime : suggestedEndTime // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
