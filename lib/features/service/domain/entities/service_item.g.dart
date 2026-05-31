// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LaborItemImpl _$$LaborItemImplFromJson(Map<String, dynamic> json) =>
    _$LaborItemImpl(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LaborItemImplToJson(_$LaborItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'runtimeType': instance.$type,
    };

_$PartItemImpl _$$PartItemImplFromJson(Map<String, dynamic> json) =>
    _$PartItemImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PartItemImplToJson(_$PartItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'runtimeType': instance.$type,
    };
