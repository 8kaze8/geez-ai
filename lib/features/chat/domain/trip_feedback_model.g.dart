// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripFeedbackModel _$TripFeedbackModelFromJson(Map<String, dynamic> json) =>
    _TripFeedbackModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routeId: json['routeId'] as String,
      overallRating: (json['overallRating'] as num?)?.toInt(),
      foodRating: json['foodRating'] as String?,
      paceFeedback: json['paceFeedback'] as String?,
      favoriteStops:
          (json['favoriteStops'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      dislikedStops:
          (json['dislikedStops'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      freeText: json['freeText'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TripFeedbackModelToJson(_TripFeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routeId': instance.routeId,
      'overallRating': instance.overallRating,
      'foodRating': instance.foodRating,
      'paceFeedback': instance.paceFeedback,
      'favoriteStops': instance.favoriteStops,
      'dislikedStops': instance.dislikedStops,
      'freeText': instance.freeText,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
