import 'package:freezed_annotation/freezed_annotation.dart';

part 'passport_stamp_model.freezed.dart';
part 'passport_stamp_model.g.dart';

@freezed
abstract class PassportStampModel with _$PassportStampModel {
  const factory PassportStampModel({
    required String id,
    required String userId,
    String? routeId,
    required String city,
    required String country,
    String? countryCode,
    required String stampDate,
    String? stampImageUrl,
    DateTime? createdAt,
  }) = _PassportStampModel;

  factory PassportStampModel.fromJson(Map<String, dynamic> json) =>
      _$PassportStampModelFromJson(json);
}
