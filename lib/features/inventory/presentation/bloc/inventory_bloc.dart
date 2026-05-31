import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

// Events
abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchInventory extends InventoryEvent {
  const FetchInventory();
}

class AddInventoryItem extends InventoryEvent {
  final InventoryItem item;
  const AddInventoryItem(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateInventoryItem extends InventoryEvent {
  final InventoryItem item;
  const UpdateInventoryItem(this.item);
  @override
  List<Object?> get props => [item];
}

class AdjustStock extends InventoryEvent {
  final String id;
  final int delta;
  const AdjustStock(this.id, this.delta);
  @override
  List<Object?> get props => [id, delta];
}

class DeleteInventoryItem extends InventoryEvent {
  final String id;
  const DeleteInventoryItem(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class InventoryState extends Equatable {
  const InventoryState();
  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;
  const InventoryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class InventoryOperationSuccess extends InventoryState {
  final String message;
  const InventoryOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repository;

  InventoryBloc({required this.repository}) : super(InventoryInitial()) {
    on<FetchInventory>(_onFetchInventory);
    on<AddInventoryItem>(_onAddInventoryItem);
    on<UpdateInventoryItem>(_onUpdateInventoryItem);
    on<AdjustStock>(_onAdjustStock);
    on<DeleteInventoryItem>(_onDeleteInventoryItem);
  }

  Future<void> _onFetchInventory(FetchInventory event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await repository.getAllItems();
    result.fold(
      (failure) => emit(const InventoryError('Failed to fetch inventory')),
      (items) => emit(InventoryLoaded(items)),
    );
  }

  Future<void> _onAddInventoryItem(AddInventoryItem event, Emitter<InventoryState> emit) async {
    final result = await repository.addItem(event.item);
    result.fold(
      (failure) => emit(const InventoryError('Failed to add item')),
      (_) {
        emit(const InventoryOperationSuccess('Berhasil menambah item'));
        add(const FetchInventory());
      },
    );
  }

  Future<void> _onUpdateInventoryItem(UpdateInventoryItem event, Emitter<InventoryState> emit) async {
    final result = await repository.updateItem(event.item);
    result.fold(
      (failure) => emit(const InventoryError('Failed to update item')),
      (_) => add(const FetchInventory()),
    );
  }

  Future<void> _onAdjustStock(AdjustStock event, Emitter<InventoryState> emit) async {
    final result = await repository.adjustStock(event.id, event.delta);
    result.fold(
      (failure) => emit(const InventoryError('Failed to adjust stock')),
      (_) => add(const FetchInventory()),
    );
  }

  Future<void> _onDeleteInventoryItem(DeleteInventoryItem event, Emitter<InventoryState> emit) async {
    final result = await repository.deleteItem(event.id);
    result.fold(
      (failure) => emit(const InventoryError('Failed to delete item')),
      (_) => add(const FetchInventory()),
    );
  }
}
