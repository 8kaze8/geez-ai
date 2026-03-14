// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      ageGroup: json['age_group'] as String?,
      travelCompanion: json['travel_companion'] as String?,
      defaultBudget: json['default_budget'] as String?,
      preferredActivities:
          (json['preferred_activities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      foodPreferences:
          json['food_preferences'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      pacePreference: json['pace_preference'] as String? ?? 'normal',
      morningPerson: json['morning_person'] as bool? ?? true,
      crowdTolerance: json['crowd_tolerance'] as String? ?? 'medium',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'age_group': instance.ageGroup,
      'travel_companion': instance.travelCompanion,
      'default_budget': instance.defaultBudget,
      'preferred_activities': instance.preferredActivities,
      'food_preferences': instance.foodPreferences,
      'pace_preference': instance.pacePreference,
      'morning_person': instance.morningPerson,
      'crowd_tolerance': instance.crowdTolerance,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
