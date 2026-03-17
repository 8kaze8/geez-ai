import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_feedback_model.freezed.dart';
part 'trip_feedback_model.g.dart';

@freezed
abstract class TripFeedbackModel with _$TripFeedbackModel {
  const factory TripFeedbackModel({
    required String id,
    required String userId,
    required String routeId,
    int? overallRating,
    String? foodRating,
    String? paceFeedback,
    @Default(<String>[]) List<String> favoriteStops,
    @Default(<String>[]) List<String> dislikedStops,
    String? freeText,
    DateTime? createdAt,
  }) = _TripFeedbackModel;

  factory TripFeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$TripFeedbackModelFromJson(json);
}
