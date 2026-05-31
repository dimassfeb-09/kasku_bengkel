import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_item.freezed.dart';
part 'service_item.g.dart';

@freezed
sealed class ServiceItem with _$ServiceItem {
  const ServiceItem._();

  const factory ServiceItem.labor({
    required String name,
    required double price,
  }) = LaborItem;

  const factory ServiceItem.part({
    required String name,
    required int quantity,
    required double unitPrice,
  }) = PartItem;

  double get subtotal => when(
        labor: (_, price) => price,
        part: (_, quantity, unitPrice) => quantity * unitPrice,
      );

  factory ServiceItem.fromJson(Map<String, dynamic> json) => _$ServiceItemFromJson(json);
}
