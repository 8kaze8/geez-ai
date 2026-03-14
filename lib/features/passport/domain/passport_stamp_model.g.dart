// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_stamp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PassportStampModel _$PassportStampModelFromJson(Map<String, dynamic> json) =>
    _PassportStampModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      routeId: json['route_id'] as String?,
      city: json['city'] as String,
      country: json['country'] as String,
      countryCode: json['country_code'] as String?,
      stampDate: json['stamp_date'] as String,
      stampImageUrl: json['stamp_image_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PassportStampModelToJson(_PassportStampModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'route_id': instance.routeId,
      'city': instance.city,
      'country': instance.country,
      'country_code': instance.countryCode,
      'stamp_date': instance.stampDate,
      'stamp_image_url': instance.stampImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
