// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visited_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitedPlaceModel _$VisitedPlaceModelFromJson(Map<String, dynamic> json) =>
    _VisitedPlaceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      placeId: json['place_id'] as String?,
      placeName: json['place_name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      category: json['category'] as String?,
      userRating: (json['user_rating'] as num?)?.toInt(),
      visitedAt: json['visited_at'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VisitedPlaceModelToJson(_VisitedPlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'place_id': instance.placeId,
      'place_name': instance.placeName,
      'city': instance.city,
      'country': instance.country,
      'category': instance.category,
      'user_rating': instance.userRating,
      'visited_at': instance.visitedAt,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
