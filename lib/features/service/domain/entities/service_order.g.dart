// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleInfoImpl _$$VehicleInfoImplFromJson(Map<String, dynamic> json) =>
    _$VehicleInfoImpl(
      plateNumber: json['plateNumber'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String,
      vehicleType: json['vehicleType'] as String,
      vehicleBrand: json['vehicleBrand'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
    );

Map<String, dynamic> _$$VehicleInfoImplToJson(_$VehicleInfoImpl instance) =>
    <String, dynamic>{
      'plateNumber': instance.plateNumber,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'vehicleType': instance.vehicleType,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleModel': instance.vehicleModel,
    };

_$ServiceOrderImpl _$$ServiceOrderImplFromJson(Map<String, dynamic> json) =>
    _$ServiceOrderImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String?,
      vehicleInfo: VehicleInfo.fromJson(
        json['vehicleInfo'] as Map<String, dynamic>,
      ),
      complaint: json['complaint'] as String,
      mechanicName: json['mechanicName'] as String?,
      status:
          $enumDecodeNullable(_$ServiceStatusEnumMap, json['status']) ??
          ServiceStatus.antri,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      readyAt: json['readyAt'] == null
          ? null
          : DateTime.parse(json['readyAt'] as String),
    );

Map<String, dynamic> _$$ServiceOrderImplToJson(_$ServiceOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'vehicleInfo': instance.vehicleInfo,
      'complaint': instance.complaint,
      'mechanicName': instance.mechanicName,
      'status': _$ServiceStatusEnumMap[instance.status]!,
      'items': instance.items,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'readyAt': instance.readyAt?.toIso8601String(),
    };

const _$ServiceStatusEnumMap = {
  ServiceStatus.antri: 'antri',
  ServiceStatus.dikerjakan: 'dikerjakan',
  ServiceStatus.selesai: 'selesai',
  ServiceStatus.siapDiambil: 'siapDiambil',
  ServiceStatus.lunas: 'lunas',
};
