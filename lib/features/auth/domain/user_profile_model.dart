import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String userId,
    String? ageGroup,
    String? travelCompanion,
    String? defaultBudget,
    @Default(<String>[]) List<String> preferredActivities,
    @Default(<String, dynamic>{}) Map<String, dynamic> foodPreferences,
    @Default('normal') String pacePreference,
    @Default(true) bool morningPerson,
    @Default('medium') String crowdTolerance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}
