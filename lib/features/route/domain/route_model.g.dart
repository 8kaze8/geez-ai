// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => _RouteModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
  title: json['title'] as String,
  durationDays: (json['duration_days'] as num).toInt(),
  travelStyle: json['travel_style'] as String,
  transportMode: json['transport_mode'] as String,
  budgetLevel: json['budget_level'] as String,
  status: json['status'] as String? ?? 'draft',
  startTime: json['start_time'] as String? ?? '09:00',
  language: json['language'] as String? ?? 'tr',
  aiModelUsed: json['ai_model_used'] as String?,
  generationCostUsd: (json['generation_cost_usd'] as num?)?.toDouble(),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RouteModelToJson(_RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'city': instance.city,
      'country': instance.country,
      'title': instance.title,
      'duration_days': instance.durationDays,
      'travel_style': instance.travelStyle,
      'transport_mode': instance.transportMode,
      'budget_level': instance.budgetLevel,
      'status': instance.status,
      'start_time': instance.startTime,
      'language': instance.language,
      'ai_model_used': instance.aiModelUsed,
      'generation_cost_usd': instance.generationCostUsd,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
