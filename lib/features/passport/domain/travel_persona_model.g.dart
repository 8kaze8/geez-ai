// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_persona_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TravelPersonaModel _$TravelPersonaModelFromJson(
  Map<String, dynamic> json,
) => _TravelPersonaModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  foodieLevel: (json['foodie_level'] as num?)?.toInt() ?? 1,
  historyBuffLevel: (json['history_buff_level'] as num?)?.toInt() ?? 1,
  natureLoverLevel: (json['nature_lover_level'] as num?)?.toInt() ?? 1,
  adventureSeekerLevel: (json['adventure_seeker_level'] as num?)?.toInt() ?? 1,
  cultureExplorerLevel: (json['culture_explorer_level'] as num?)?.toInt() ?? 1,
  discoveryScore: (json['discovery_score'] as num?)?.toInt() ?? 0,
  explorerTier: json['explorer_tier'] as String? ?? 'tourist',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TravelPersonaModelToJson(_TravelPersonaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'foodie_level': instance.foodieLevel,
      'history_buff_level': instance.historyBuffLevel,
      'nature_lover_level': instance.natureLoverLevel,
      'adventure_seeker_level': instance.adventureSeekerLevel,
      'culture_explorer_level': instance.cultureExplorerLevel,
      'discovery_score': instance.discoveryScore,
      'explorer_tier': instance.explorerTier,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
