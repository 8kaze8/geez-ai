// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passport_stamp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PassportStampModel _$PassportStampModelFromJson(Map<String, dynamic> json) =>
    _PassportStampModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routeId: json['routeId'] as String?,
      city: json['city'] as String,
      country: json['country'] as String,
      countryCode: json['countryCode'] as String?,
      stampDate: json['stampDate'] as String,
      stampImageUrl: json['stampImageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PassportStampModelToJson(_PassportStampModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routeId': instance.routeId,
      'city': instance.city,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'stampDate': instance.stampDate,
      'stampImageUrl': instance.stampImageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
