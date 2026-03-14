import 'package:freezed_annotation/freezed_annotation.dart';

part 'visited_place_model.freezed.dart';
part 'visited_place_model.g.dart';

@freezed
abstract class VisitedPlaceModel with _$VisitedPlaceModel {
  const factory VisitedPlaceModel({
    required String id,
    required String userId,
    String? placeId,
    required String placeName,
    required String city,
    required String country,
    String? category,
    int? userRating,
    // DATE value from DB — stored as yyyy-MM-dd string
    String? visitedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VisitedPlaceModel;

  factory VisitedPlaceModel.fromJson(Map<String, dynamic> json) =>
      _$VisitedPlaceModelFromJson(json);
}
