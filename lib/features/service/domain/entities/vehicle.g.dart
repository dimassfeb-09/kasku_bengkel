// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      plateNumber: json['plateNumber'] as String,
      customerId: json['customerId'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plateNumber': instance.plateNumber,
      'customerId': instance.customerId,
      'type': instance.type,
      'brand': instance.brand,
      'model': instance.model,
      'createdAt': instance.createdAt.toIso8601String(),
    };
