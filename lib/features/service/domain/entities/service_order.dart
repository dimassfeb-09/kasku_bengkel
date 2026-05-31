import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_item.dart';
import 'service_status.dart';

part 'service_order.freezed.dart';
part 'service_order.g.dart';

@freezed
class VehicleInfo with _$VehicleInfo {
  const factory VehicleInfo({
    required String plateNumber,
    required String ownerName,
    required String ownerPhone,
    required String vehicleType,
    String? vehicleBrand,
    String? vehicleModel,
  }) = _VehicleInfo;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => _$VehicleInfoFromJson(json);
}

@freezed
class ServiceOrder with _$ServiceOrder {
  const ServiceOrder._();

  const factory ServiceOrder({
    required String id,
    required VehicleInfo vehicleInfo,
    required String complaint,
    String? mechanicName,
    @Default(ServiceStatus.antri) ServiceStatus status,
    @Default([]) List<ServiceItem> items,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    DateTime? readyAt,
  }) = _ServiceOrder;

  double get totalEstimation => items.fold(0, (sum, item) => sum + item.subtotal);

  factory ServiceOrder.fromJson(Map<String, dynamic> json) => _$ServiceOrderFromJson(json);
}
