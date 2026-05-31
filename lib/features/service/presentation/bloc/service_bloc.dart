import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/repositories/service_repository.dart';

// Events
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchServices extends ServiceEvent {}

class AddServiceOrder extends ServiceEvent {
  final ServiceOrder order;
  const AddServiceOrder(this.order);

  @override
  List<Object?> get props => [order];
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
  final int itemIndex;
  const RemoveServiceItem(this.id, this.itemIndex);

  @override
  List<Object?> get props => [id, itemIndex];
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
  const ServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
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

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc({required this.repository}) : super(ServiceInitial()) {
    on<FetchServices>((event, emit) async {
      emit(ServiceLoading());
      final result = await repository.getActiveServices();
      result.fold(
        (failure) => emit(const ServiceError('Failed to fetch services')),
        (services) => emit(ServiceLoaded(services)),
      );
    });

    on<AddServiceOrder>((event, emit) async {
      emit(ServiceLoading());
      final result = await repository.addServiceOrder(event.order);
      result.fold(
        (failure) => emit(const ServiceError('Failed to add service order')),
        (_) {
          emit(const ServiceOperationSuccess('Service order added successfully'));
          add(FetchServices());
        },
      );
    });

    on<UpdateServiceStatus>((event, emit) async {
      final currentState = state;
      if (currentState is ServiceLoaded) {
        try {
          final currentOrder = currentState.services.firstWhere((o) => o.id == event.id);
          if (event.newStatus.index <= currentOrder.status.index) {
            emit(const ServiceError('Status can only move forward'));
            // Re-emit loaded state to allow further operations
            emit(ServiceLoaded(currentState.services));
            return;
          }

          emit(ServiceLoading());
          final result = await repository.updateServiceStatus(event.id, event.newStatus);
          result.fold(
            (failure) => emit(const ServiceError('Update failed')),
            (_) {
              emit(const ServiceOperationSuccess('Status updated successfully'));
              add(FetchServices());
            },
          );
        } catch (e) {
          emit(const ServiceError('Service order not found'));
          emit(ServiceLoaded(currentState.services));
        }
      }
    });

    on<AddServiceItem>((event, emit) async {
      emit(ServiceLoading());
      final result = await repository.addServiceItem(event.id, event.item);
      result.fold(
        (failure) => emit(const ServiceError('Failed to add item')),
        (_) {
          emit(const ServiceOperationSuccess('Item added successfully'));
          add(FetchServices());
        },
      );
    });

    on<RemoveServiceItem>((event, emit) async {
      emit(ServiceLoading());
      final result = await repository.removeServiceItem(event.id, event.itemIndex);
      result.fold(
        (failure) => emit(const ServiceError('Failed to remove item')),
        (_) {
          emit(const ServiceOperationSuccess('Item removed successfully'));
          add(FetchServices());
        },
      );
    });
  }
}
