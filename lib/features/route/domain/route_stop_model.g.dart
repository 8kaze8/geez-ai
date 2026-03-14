// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteStopModel _$RouteStopModelFromJson(Map<String, dynamic> json) =>
    _RouteStopModel(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      stopOrder: (json['stopOrder'] as num).toInt(),
      dayNumber: (json['dayNumber'] as num).toInt(),
      placeName: json['placeName'] as String,
      placeId: json['placeId'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      category: json['category'] as String?,
      description: json['description'] as String?,
      insiderTip: json['insiderTip'] as String?,
      funFact: json['funFact'] as String?,
      bestTime: json['bestTime'] as String?,
      warnings: json['warnings'] as String?,
      reviewSummary: json['reviewSummary'] as String?,
      googleRating: (json['googleRating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      estimatedDurationMin: (json['estimatedDurationMin'] as num?)?.toInt(),
      entryFeeText: json['entryFeeText'] as String?,
      entryFeeAmount: (json['entryFeeAmount'] as num?)?.toDouble(),
      entryFeeCurrency: json['entryFeeCurrency'] as String? ?? 'TRY',
      travelFromPreviousMin: (json['travelFromPreviousMin'] as num?)?.toInt(),
      travelModeFromPrevious: json['travelModeFromPrevious'] as String?,
      discoveryPoints: (json['discoveryPoints'] as num?)?.toInt() ?? 0,
      suggestedStartTime: json['suggestedStartTime'] as String?,
      suggestedEndTime: json['suggestedEndTime'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RouteStopModelToJson(_RouteStopModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'stopOrder': instance.stopOrder,
      'dayNumber': instance.dayNumber,
      'placeName': instance.placeName,
      'placeId': instance.placeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
      'description': instance.description,
      'insiderTip': instance.insiderTip,
      'funFact': instance.funFact,
      'bestTime': instance.bestTime,
      'warnings': instance.warnings,
      'reviewSummary': instance.reviewSummary,
      'googleRating': instance.googleRating,
      'reviewCount': instance.reviewCount,
      'estimatedDurationMin': instance.estimatedDurationMin,
      'entryFeeText': instance.entryFeeText,
      'entryFeeAmount': instance.entryFeeAmount,
      'entryFeeCurrency': instance.entryFeeCurrency,
      'travelFromPreviousMin': instance.travelFromPreviousMin,
      'travelModeFromPrevious': instance.travelModeFromPrevious,
      'discoveryPoints': instance.discoveryPoints,
      'suggestedStartTime': instance.suggestedStartTime,
      'suggestedEndTime': instance.suggestedEndTime,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
