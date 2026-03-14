// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      ageGroup: json['ageGroup'] as String?,
      travelCompanion: json['travelCompanion'] as String?,
      defaultBudget: json['defaultBudget'] as String?,
      preferredActivities:
          (json['preferredActivities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      foodPreferences:
          json['foodPreferences'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      pacePreference: json['pacePreference'] as String? ?? 'normal',
      morningPerson: json['morningPerson'] as bool? ?? true,
      crowdTolerance: json['crowdTolerance'] as String? ?? 'medium',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'ageGroup': instance.ageGroup,
      'travelCompanion': instance.travelCompanion,
      'defaultBudget': instance.defaultBudget,
      'preferredActivities': instance.preferredActivities,
      'foodPreferences': instance.foodPreferences,
      'pacePreference': instance.pacePreference,
      'morningPerson': instance.morningPerson,
      'crowdTolerance': instance.crowdTolerance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
