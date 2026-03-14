// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => _RouteModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
  title: json['title'] as String,
  durationDays: (json['durationDays'] as num).toInt(),
  travelStyle: json['travelStyle'] as String,
  transportMode: json['transportMode'] as String,
  budgetLevel: json['budgetLevel'] as String,
  status: json['status'] as String? ?? 'draft',
  startTime: json['startTime'] as String? ?? '09:00',
  language: json['language'] as String? ?? 'tr',
  aiModelUsed: json['aiModelUsed'] as String?,
  generationCostUsd: (json['generationCostUsd'] as num?)?.toDouble(),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RouteModelToJson(_RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'city': instance.city,
      'country': instance.country,
      'title': instance.title,
      'durationDays': instance.durationDays,
      'travelStyle': instance.travelStyle,
      'transportMode': instance.transportMode,
      'budgetLevel': instance.budgetLevel,
      'status': instance.status,
      'startTime': instance.startTime,
      'language': instance.language,
      'aiModelUsed': instance.aiModelUsed,
      'generationCostUsd': instance.generationCostUsd,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
