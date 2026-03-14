// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_persona_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TravelPersonaModel _$TravelPersonaModelFromJson(
  Map<String, dynamic> json,
) => _TravelPersonaModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  foodieLevel: (json['foodieLevel'] as num?)?.toInt() ?? 1,
  historyBuffLevel: (json['historyBuffLevel'] as num?)?.toInt() ?? 1,
  natureLoverLevel: (json['natureLoverLevel'] as num?)?.toInt() ?? 1,
  adventureSeekerLevel: (json['adventureSeekerLevel'] as num?)?.toInt() ?? 1,
  cultureExplorerLevel: (json['cultureExplorerLevel'] as num?)?.toInt() ?? 1,
  discoveryScore: (json['discoveryScore'] as num?)?.toInt() ?? 0,
  explorerTier: json['explorerTier'] as String? ?? 'tourist',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TravelPersonaModelToJson(_TravelPersonaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'foodieLevel': instance.foodieLevel,
      'historyBuffLevel': instance.historyBuffLevel,
      'natureLoverLevel': instance.natureLoverLevel,
      'adventureSeekerLevel': instance.adventureSeekerLevel,
      'cultureExplorerLevel': instance.cultureExplorerLevel,
      'discoveryScore': instance.discoveryScore,
      'explorerTier': instance.explorerTier,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
