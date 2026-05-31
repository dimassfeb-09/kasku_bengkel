// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      sku: json['sku'] as String?,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      minStockLevel: (json['minStockLevel'] as num?)?.toInt() ?? 5,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'sku': instance.sku,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'stock': instance.stock,
      'minStockLevel': instance.minStockLevel,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ItemTypeEnumMap = {ItemType.part: 'part', ItemType.labor: 'labor'};
