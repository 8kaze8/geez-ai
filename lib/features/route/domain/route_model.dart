import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
abstract class RouteModel with _$RouteModel {
  const factory RouteModel({
    required String id,
    required String userId,
    required String city,
    required String country,
    required String title,
    required int durationDays,
    required String travelStyle,
    required String transportMode,
    required String budgetLevel,
    @Default('draft') String status,
    @Default('09:00') String startTime,
    @Default('tr') String language,
    String? aiModelUsed,
    double? generationCostUsd,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}
