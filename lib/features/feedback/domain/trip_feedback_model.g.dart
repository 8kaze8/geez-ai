// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripFeedbackModel _$TripFeedbackModelFromJson(Map<String, dynamic> json) =>
    _TripFeedbackModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      routeId: json['route_id'] as String,
      overallRating: (json['overall_rating'] as num?)?.toInt(),
      foodRating: json['food_rating'] as String?,
      paceFeedback: json['pace_feedback'] as String?,
      favoriteStops:
          (json['favorite_stops'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      dislikedStops:
          (json['disliked_stops'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      freeText: json['free_text'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TripFeedbackModelToJson(_TripFeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'route_id': instance.routeId,
      'overall_rating': instance.overallRating,
      'food_rating': instance.foodRating,
      'pace_feedback': instance.paceFeedback,
      'favorite_stops': instance.favoriteStops,
      'disliked_stops': instance.dislikedStops,
      'free_text': instance.freeText,
      'created_at': instance.createdAt?.toIso8601String(),
    };
