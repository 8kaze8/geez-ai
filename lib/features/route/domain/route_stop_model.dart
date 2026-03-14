import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_stop_model.freezed.dart';
part 'route_stop_model.g.dart';

@freezed
abstract class RouteStopModel with _$RouteStopModel {
  const factory RouteStopModel({
    required String id,
    required String routeId,
    required int stopOrder,
    required int dayNumber,
    required String placeName,
    String? placeId,
    double? latitude,
    double? longitude,
    String? category,
    String? description,
    String? insiderTip,
    String? funFact,
    String? bestTime,
    String? warnings,
    String? reviewSummary,
    double? googleRating,
    int? reviewCount,
    int? estimatedDurationMin,
    String? entryFeeText,
    double? entryFeeAmount,
    @Default('TRY') String entryFeeCurrency,
    int? travelFromPreviousMin,
    String? travelModeFromPrevious,
    @Default(0) int discoveryPoints,
    // TIME values from DB — stored as HH:mm string
    String? suggestedStartTime,
    String? suggestedEndTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RouteStopModel;

  factory RouteStopModel.fromJson(Map<String, dynamic> json) =>
      _$RouteStopModelFromJson(json);
}
