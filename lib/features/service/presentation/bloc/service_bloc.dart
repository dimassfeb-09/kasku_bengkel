import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/repositories/service_repository.dart';

import '../../domain/entities/customer.dart';
import '../../domain/entities/vehicle.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';

// Events
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
  @override
  List<Object?> get props => [];
}

class FetchServices extends ServiceEvent {
  const FetchServices();
}

class AddServiceOrder extends ServiceEvent {
  final ServiceOrder order;
  final bool saveToMaster;
  const AddServiceOrder(this.order, {this.saveToMaster = false});
  @override
  List<Object?> get props => [order, saveToMaster];
}

class SearchVehicleByPlate extends ServiceEvent {
  final String plateNumber;
  const SearchVehicleByPlate(this.plateNumber);
  @override
  List<Object?> get props => [plateNumber];
}

class UpdateServiceStatus extends ServiceEvent {
  final String id;
  final ServiceStatus newStatus;
  const UpdateServiceStatus(this.id, this.newStatus);
  @override
  List<Object?> get props => [id, newStatus];
}

class AddServiceItem extends ServiceEvent {
  final String id;
  final ServiceItem item;
  const AddServiceItem(this.id, this.item);
  @override
  List<Object?> get props => [id, item];
}

class RemoveServiceItem extends ServiceEvent {
  final String id;
  final int index;
  const RemoveServiceItem(this.id, this.index);
  @override
  List<Object?> get props => [id, index];
}

// States
abstract class ServiceState extends Equatable {
  const ServiceState();
  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<ServiceOrder> services;
  final Vehicle? searchedVehicle;
  final Customer? searchedCustomer;

  const ServiceLoaded(this.services, {this.searchedVehicle, this.searchedCustomer});
  @override
  List<Object?> get props => [services, searchedVehicle, searchedCustomer];
}

class ServiceOperationSuccess extends ServiceState {
  final String message;
  const ServiceOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ServiceError extends ServiceState {
  final String message;
  const ServiceError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;
  final InventoryRepository inventoryRepository;

  ServiceBloc({
    required this.repository,
    required this.inventoryRepository,
  }) : super(ServiceInitial()) {
    on<FetchServices>(_onFetchServices);
    on<AddServiceOrder>(_onAddServiceOrder);
    on<UpdateServiceStatus>(_onUpdateServiceStatus);
    on<AddServiceItem>(_onAddServiceItem);
    on<RemoveServiceItem>(_onRemoveServiceItem);
    on<SearchVehicleByPlate>(_onSearchVehicleByPlate);
  }

  Future<void> _onFetchServices(FetchServices event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.getActiveServices();
    result.fold(
      (failure) => emit(const ServiceError('Failed to fetch services')),
      (services) => emit(ServiceLoaded(services)),
    );
  }

  Future<void> _onSearchVehicleByPlate(SearchVehicleByPlate event, Emitter<ServiceState> emit) async {
    if (event.plateNumber.length < 3) return;

    final vehicleResult = await repository.findVehicleByPlate(event.plateNumber);
    
    await vehicleResult.fold(
      (failure) async {},
      (vehicle) async {
        if (vehicle != null) {
          final customerResult = await repository.findCustomerByPhone(vehicle.customerId);
          customerResult.fold(
            (_) {},
            (customer) {
              if (state is ServiceLoaded) {
                final current = state as ServiceLoaded;
                emit(ServiceLoaded(current.services, searchedVehicle: vehicle, searchedCustomer: customer));
              }
            },
          );
        }
      },
    );
  }

  Future<void> _onAddServiceOrder(AddServiceOrder event, Emitter<ServiceState> emit) async {
    if (event.saveToMaster) {
      // 1. Save/Update Customer
      final customer = Customer(
        id: event.order.vehicleInfo.ownerPhone,
        name: event.order.vehicleInfo.ownerName,
        phone: event.order.vehicleInfo.ownerPhone,
        createdAt: DateTime.now(),
      );
      await repository.saveCustomer(customer);

      // 2. Save/Update Vehicle
      final vehicle = Vehicle(
        id: event.order.vehicleInfo.plateNumber,
        plateNumber: event.order.vehicleInfo.plateNumber,
        customerId: customer.id,
        type: event.order.vehicleInfo.vehicleType,
        brand: event.order.vehicleInfo.vehicleBrand,
        model: event.order.vehicleInfo.vehicleModel,
        createdAt: DateTime.now(),
      );
      await repository.saveVehicle(vehicle);
    }

    final result = await repository.addServiceOrder(event.order);
    result.fold(
      (failure) => emit(const ServiceError('Failed to add service')),
      (_) {
        emit(const ServiceOperationSuccess('Berhasil menambah antrian'));
        add(const FetchServices());
      },
    );
  }

  Future<void> _onUpdateServiceStatus(UpdateServiceStatus event, Emitter<ServiceState> emit) async {
    final result = await repository.updateServiceStatus(event.id, event.newStatus);
    result.fold(
      (failure) => emit(const ServiceError('Update failed')),
      (_) => add(const FetchServices()),
    );
  }

  Future<void> _onAddServiceItem(AddServiceItem event, Emitter<ServiceState> emit) async {
    // 1. If it's a part, decrease stock immediately (Option 2 choice)
    await event.item.maybeMap(
      part: (part) async {
        final catalog = await inventoryRepository.getAllItems();
        catalog.fold((_) {}, (items) async {
          final matched = items.where((i) => i.name == part.name).firstOrNull;
          if (matched != null) {
            await inventoryRepository.adjustStock(matched.id, -part.quantity);
          }
        });
      },
      orElse: () async {},
    );

    final result = await repository.addServiceItem(event.id, event.item);
    result.fold(
      (failure) => emit(const ServiceError('Failed to add item')),
      (_) {
        emit(const ServiceOperationSuccess('Berhasil menambah item'));
        add(const FetchServices());
      },
    );
  }

  Future<void> _onRemoveServiceItem(RemoveServiceItem event, Emitter<ServiceState> emit) async {
    final services = await repository.getActiveServices();
    await services.fold((_) async {}, (list) async {
      final order = list.where((o) => o.id == event.id).firstOrNull;
      if (order != null && event.index < order.items.length) {
        final item = order.items[event.index];
        await item.maybeMap(
          part: (part) async {
            final catalog = await inventoryRepository.getAllItems();
            catalog.fold((_) {}, (items) async {
              final matched = items.where((i) => i.name == part.name).firstOrNull;
              if (matched != null) {
                await inventoryRepository.adjustStock(matched.id, part.quantity);
              }
            });
          },
          orElse: () async {},
        );
      }
    });

    final result = await repository.removeServiceItem(event.id, event.index);
    result.fold(
      (failure) => emit(const ServiceError('Failed to remove item')),
      (_) => add(const FetchServices()),
    );
  }
}
