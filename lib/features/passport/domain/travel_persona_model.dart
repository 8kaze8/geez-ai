import 'package:freezed_annotation/freezed_annotation.dart';

part 'travel_persona_model.freezed.dart';
part 'travel_persona_model.g.dart';

@freezed
abstract class TravelPersonaModel with _$TravelPersonaModel {
  const factory TravelPersonaModel({
    required String id,
    required String userId,
    @Default(1) int foodieLevel,
    @Default(1) int historyBuffLevel,
    @Default(1) int natureLoverLevel,
    @Default(1) int adventureSeekerLevel,
    @Default(1) int cultureExplorerLevel,
    @Default(0) int discoveryScore,
    @Default('tourist') String explorerTier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TravelPersonaModel;

  factory TravelPersonaModel.fromJson(Map<String, dynamic> json) =>
      _$TravelPersonaModelFromJson(json);
}
