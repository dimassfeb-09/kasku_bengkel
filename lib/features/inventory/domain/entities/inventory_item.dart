import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

enum ItemType { part, labor }

@freezed
class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required String name,
    required ItemType type,
    String? sku,
    required double purchasePrice,
    required double sellingPrice,
    @Default(0) int stock,
    @Default(5) int minStockLevel,
    required DateTime createdAt,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}
