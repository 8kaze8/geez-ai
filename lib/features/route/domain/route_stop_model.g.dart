// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteStopModel _$RouteStopModelFromJson(Map<String, dynamic> json) =>
    _RouteStopModel(
      id: json['id'] as String,
      routeId: json['route_id'] as String,
      stopOrder: (json['stop_order'] as num).toInt(),
      dayNumber: (json['day_number'] as num).toInt(),
      placeName: json['place_name'] as String,
      placeId: json['place_id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      category: json['category'] as String?,
      description: json['description'] as String?,
      insiderTip: json['insider_tip'] as String?,
      funFact: json['fun_fact'] as String?,
      bestTime: json['best_time'] as String?,
      warnings: json['warnings'] as String?,
      reviewSummary: json['review_summary'] as String?,
      googleRating: (json['google_rating'] as num?)?.toDouble(),
      reviewCount: (json['review_count'] as num?)?.toInt(),
      estimatedDurationMin: (json['estimated_duration_min'] as num?)?.toInt(),
      entryFeeText: json['entry_fee_text'] as String?,
      entryFeeAmount: (json['entry_fee_amount'] as num?)?.toDouble(),
      entryFeeCurrency: json['entry_fee_currency'] as String? ?? 'TRY',
      travelFromPreviousMin: (json['travel_from_previous_min'] as num?)
          ?.toInt(),
      travelModeFromPrevious: json['travel_mode_from_previous'] as String?,
      discoveryPoints: (json['discovery_points'] as num?)?.toInt() ?? 0,
      suggestedStartTime: json['suggested_start_time'] as String?,
      suggestedEndTime: json['suggested_end_time'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RouteStopModelToJson(_RouteStopModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'route_id': instance.routeId,
      'stop_order': instance.stopOrder,
      'day_number': instance.dayNumber,
      'place_name': instance.placeName,
      'place_id': instance.placeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
      'description': instance.description,
      'insider_tip': instance.insiderTip,
      'fun_fact': instance.funFact,
      'best_time': instance.bestTime,
      'warnings': instance.warnings,
      'review_summary': instance.reviewSummary,
      'google_rating': instance.googleRating,
      'review_count': instance.reviewCount,
      'estimated_duration_min': instance.estimatedDurationMin,
      'entry_fee_text': instance.entryFeeText,
      'entry_fee_amount': instance.entryFeeAmount,
      'entry_fee_currency': instance.entryFeeCurrency,
      'travel_from_previous_min': instance.travelFromPreviousMin,
      'travel_mode_from_previous': instance.travelModeFromPrevious,
      'discovery_points': instance.discoveryPoints,
      'suggested_start_time': instance.suggestedStartTime,
      'suggested_end_time': instance.suggestedEndTime,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
