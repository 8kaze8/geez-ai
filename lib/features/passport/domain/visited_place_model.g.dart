// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visited_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitedPlaceModel _$VisitedPlaceModelFromJson(Map<String, dynamic> json) =>
    _VisitedPlaceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      placeId: json['placeId'] as String?,
      placeName: json['placeName'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      category: json['category'] as String?,
      userRating: (json['userRating'] as num?)?.toInt(),
      visitedAt: json['visitedAt'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VisitedPlaceModelToJson(_VisitedPlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'placeId': instance.placeId,
      'placeName': instance.placeName,
      'city': instance.city,
      'country': instance.country,
      'category': instance.category,
      'userRating': instance.userRating,
      'visitedAt': instance.visitedAt,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
