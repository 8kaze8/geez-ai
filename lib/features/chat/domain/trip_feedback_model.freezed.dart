// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripFeedbackModel {

 String get id; String get userId; String get routeId; int? get overallRating; String? get foodRating; String? get paceFeedback; List<String> get favoriteStops; List<String> get dislikedStops; String? get freeText; DateTime? get createdAt;
/// Create a copy of TripFeedbackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripFeedbackModelCopyWith<TripFeedbackModel> get copyWith => _$TripFeedbackModelCopyWithImpl<TripFeedbackModel>(this as TripFeedbackModel, _$identity);

  /// Serializes this TripFeedbackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripFeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.overallRating, overallRating) || other.overallRating == overallRating)&&(identical(other.foodRating, foodRating) || other.foodRating == foodRating)&&(identical(other.paceFeedback, paceFeedback) || other.paceFeedback == paceFeedback)&&const DeepCollectionEquality().equals(other.favoriteStops, favoriteStops)&&const DeepCollectionEquality().equals(other.dislikedStops, dislikedStops)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,routeId,overallRating,foodRating,paceFeedback,const DeepCollectionEquality().hash(favoriteStops),const DeepCollectionEquality().hash(dislikedStops),freeText,createdAt);

@override
String toString() {
  return 'TripFeedbackModel(id: $id, userId: $userId, routeId: $routeId, overallRating: $overallRating, foodRating: $foodRating, paceFeedback: $paceFeedback, favoriteStops: $favoriteStops, dislikedStops: $dislikedStops, freeText: $freeText, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TripFeedbackModelCopyWith<$Res>  {
  factory $TripFeedbackModelCopyWith(TripFeedbackModel value, $Res Function(TripFeedbackModel) _then) = _$TripFeedbackModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String routeId, int? overallRating, String? foodRating, String? paceFeedback, List<String> favoriteStops, List<String> dislikedStops, String? freeText, DateTime? createdAt
});




}
/// @nodoc
class _$TripFeedbackModelCopyWithImpl<$Res>
    implements $TripFeedbackModelCopyWith<$Res> {
  _$TripFeedbackModelCopyWithImpl(this._self, this._then);

  final TripFeedbackModel _self;
  final $Res Function(TripFeedbackModel) _then;

/// Create a copy of TripFeedbackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? routeId = null,Object? overallRating = freezed,Object? foodRating = freezed,Object? paceFeedback = freezed,Object? favoriteStops = null,Object? dislikedStops = null,Object? freeText = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,overallRating: freezed == overallRating ? _self.overallRating : overallRating // ignore: cast_nullable_to_non_nullable
as int?,foodRating: freezed == foodRating ? _self.foodRating : foodRating // ignore: cast_nullable_to_non_nullable
as String?,paceFeedback: freezed == paceFeedback ? _self.paceFeedback : paceFeedback // ignore: cast_nullable_to_non_nullable
as String?,favoriteStops: null == favoriteStops ? _self.favoriteStops : favoriteStops // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedStops: null == dislikedStops ? _self.dislikedStops : dislikedStops // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripFeedbackModel].
extension TripFeedbackModelPatterns on TripFeedbackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripFeedbackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripFeedbackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripFeedbackModel value)  $default,){
final _that = this;
switch (_that) {
case _TripFeedbackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripFeedbackModel value)?  $default,){
final _that = this;
switch (_that) {
case _TripFeedbackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String routeId,  int? overallRating,  String? foodRating,  String? paceFeedback,  List<String> favoriteStops,  List<String> dislikedStops,  String? freeText,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripFeedbackModel() when $default != null:
return $default(_that.id,_that.userId,_that.routeId,_that.overallRating,_that.foodRating,_that.paceFeedback,_that.favoriteStops,_that.dislikedStops,_that.freeText,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String routeId,  int? overallRating,  String? foodRating,  String? paceFeedback,  List<String> favoriteStops,  List<String> dislikedStops,  String? freeText,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TripFeedbackModel():
return $default(_that.id,_that.userId,_that.routeId,_that.overallRating,_that.foodRating,_that.paceFeedback,_that.favoriteStops,_that.dislikedStops,_that.freeText,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String routeId,  int? overallRating,  String? foodRating,  String? paceFeedback,  List<String> favoriteStops,  List<String> dislikedStops,  String? freeText,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TripFeedbackModel() when $default != null:
return $default(_that.id,_that.userId,_that.routeId,_that.overallRating,_that.foodRating,_that.paceFeedback,_that.favoriteStops,_that.dislikedStops,_that.freeText,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripFeedbackModel implements TripFeedbackModel {
  const _TripFeedbackModel({required this.id, required this.userId, required this.routeId, this.overallRating, this.foodRating, this.paceFeedback, final  List<String> favoriteStops = const <String>[], final  List<String> dislikedStops = const <String>[], this.freeText, this.createdAt}): _favoriteStops = favoriteStops,_dislikedStops = dislikedStops;
  factory _TripFeedbackModel.fromJson(Map<String, dynamic> json) => _$TripFeedbackModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String routeId;
@override final  int? overallRating;
@override final  String? foodRating;
@override final  String? paceFeedback;
 final  List<String> _favoriteStops;
@override@JsonKey() List<String> get favoriteStops {
  if (_favoriteStops is EqualUnmodifiableListView) return _favoriteStops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteStops);
}

 final  List<String> _dislikedStops;
@override@JsonKey() List<String> get dislikedStops {
  if (_dislikedStops is EqualUnmodifiableListView) return _dislikedStops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dislikedStops);
}

@override final  String? freeText;
@override final  DateTime? createdAt;

/// Create a copy of TripFeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripFeedbackModelCopyWith<_TripFeedbackModel> get copyWith => __$TripFeedbackModelCopyWithImpl<_TripFeedbackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripFeedbackModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripFeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.overallRating, overallRating) || other.overallRating == overallRating)&&(identical(other.foodRating, foodRating) || other.foodRating == foodRating)&&(identical(other.paceFeedback, paceFeedback) || other.paceFeedback == paceFeedback)&&const DeepCollectionEquality().equals(other._favoriteStops, _favoriteStops)&&const DeepCollectionEquality().equals(other._dislikedStops, _dislikedStops)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,routeId,overallRating,foodRating,paceFeedback,const DeepCollectionEquality().hash(_favoriteStops),const DeepCollectionEquality().hash(_dislikedStops),freeText,createdAt);

@override
String toString() {
  return 'TripFeedbackModel(id: $id, userId: $userId, routeId: $routeId, overallRating: $overallRating, foodRating: $foodRating, paceFeedback: $paceFeedback, favoriteStops: $favoriteStops, dislikedStops: $dislikedStops, freeText: $freeText, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TripFeedbackModelCopyWith<$Res> implements $TripFeedbackModelCopyWith<$Res> {
  factory _$TripFeedbackModelCopyWith(_TripFeedbackModel value, $Res Function(_TripFeedbackModel) _then) = __$TripFeedbackModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String routeId, int? overallRating, String? foodRating, String? paceFeedback, List<String> favoriteStops, List<String> dislikedStops, String? freeText, DateTime? createdAt
});




}
/// @nodoc
class __$TripFeedbackModelCopyWithImpl<$Res>
    implements _$TripFeedbackModelCopyWith<$Res> {
  __$TripFeedbackModelCopyWithImpl(this._self, this._then);

  final _TripFeedbackModel _self;
  final $Res Function(_TripFeedbackModel) _then;

/// Create a copy of TripFeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? routeId = null,Object? overallRating = freezed,Object? foodRating = freezed,Object? paceFeedback = freezed,Object? favoriteStops = null,Object? dislikedStops = null,Object? freeText = freezed,Object? createdAt = freezed,}) {
  return _then(_TripFeedbackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,overallRating: freezed == overallRating ? _self.overallRating : overallRating // ignore: cast_nullable_to_non_nullable
as int?,foodRating: freezed == foodRating ? _self.foodRating : foodRating // ignore: cast_nullable_to_non_nullable
as String?,paceFeedback: freezed == paceFeedback ? _self.paceFeedback : paceFeedback // ignore: cast_nullable_to_non_nullable
as String?,favoriteStops: null == favoriteStops ? _self._favoriteStops : favoriteStops // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedStops: null == dislikedStops ? _self._dislikedStops : dislikedStops // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
