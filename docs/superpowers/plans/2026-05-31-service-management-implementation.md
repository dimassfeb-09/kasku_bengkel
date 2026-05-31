# Service Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the Service Management module including domain entities, validated status transitions, and a mocked in-memory data source.

**Architecture:** Feature-First Clean Architecture. Models are generated using Freezed. Logic resides in Use Cases and BLoCs.

**Tech Stack:** Flutter, BLoC, Freezed, Get_it, Dartz.

---

### Task 1: Domain Models (Entities & Value Objects)

**Files:**
- Create: `lib/features/service/domain/entities/service_order.dart`
- Create: `lib/features/service/domain/entities/service_item.dart`
- Create: `lib/features/service/domain/entities/service_status.dart`

- [ ] **Step 1: Define ServiceStatus Enum**
File: `lib/features/service/domain/entities/service_status.dart`
```dart
enum ServiceStatus { antri, dikerjakan, selesai, siapDiambil }
```

- [ ] **Step 2: Create ServiceItem Union Type**
File: `lib/features/service/domain/entities/service_item.dart`
```dart
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
```

- [ ] **Step 3: Create ServiceOrder Entity and VehicleInfo**
File: `lib/features/service/domain/entities/service_order.dart`
```dart
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
```

- [ ] **Step 4: Run build_runner**
Run: `dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 5: Commit**
```bash
git add lib/features/service/domain/entities/
git commit -m "feat(service): add domain entities and freezed models"
```

---

### Task 2: Repository & Mock Data Source

**Files:**
- Create: `lib/features/service/domain/repositories/service_repository.dart`
- Create: `lib/features/service/data/repositories/service_repository_impl.dart`

- [ ] **Step 1: Define Repository Interface**
File: `lib/features/service/domain/repositories/service_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_order.dart';
import '../entities/service_status.dart';
import '../entities/service_item.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceOrder>>> getActiveServices();
  Future<Either<Failure, ServiceOrder>> addServiceOrder(ServiceOrder order);
  Future<Either<Failure, ServiceOrder>> updateServiceStatus(String id, ServiceStatus newStatus);
  Future<Either<Failure, ServiceOrder>> addServiceItem(String id, ServiceItem item);
  Future<Either<Failure, ServiceOrder>> removeServiceItem(String id, int itemIndex);
}
```

- [ ] **Step 2: Implement Mock Repository**
File: `lib/features/service/data/repositories/service_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final List<ServiceOrder> _mockDb = [];

  @override
  Future<Either<Failure, List<ServiceOrder>>> getActiveServices() async {
    return Right(List.unmodifiable(_mockDb));
  }

  @override
  Future<Either<Failure, ServiceOrder>> addServiceOrder(ServiceOrder order) async {
    _mockDb.add(order);
    return Right(order);
  }

  @override
  Future<Either<Failure, ServiceOrder>> updateServiceStatus(String id, ServiceStatus newStatus) async {
    final index = _mockDb.indexWhere((o) => o.id == id);
    if (index == -1) return Left(ServerFailure());
    
    final updated = _mockDb[index].copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      completedAt: newStatus == ServiceStatus.selesai ? DateTime.now() : _mockDb[index].completedAt,
      readyAt: newStatus == ServiceStatus.siapDiambil ? DateTime.now() : _mockDb[index].readyAt,
    );
    _mockDb[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, ServiceOrder>> addServiceItem(String id, ServiceItem item) async {
    final index = _mockDb.indexWhere((o) => o.id == id);
    if (index == -1) return Left(ServerFailure());
    
    final updated = _mockDb[index].copyWith(
      items: [..._mockDb[index].items, item],
      updatedAt: DateTime.now(),
    );
    _mockDb[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, ServiceOrder>> removeServiceItem(String id, int itemIndex) async {
    final index = _mockDb.indexWhere((o) => o.id == id);
    if (index == -1) return Left(ServerFailure());
    
    final currentItems = List<ServiceItem>.from(_mockDb[index].items);
    currentItems.removeAt(itemIndex);
    
    final updated = _mockDb[index].copyWith(
      items: currentItems,
      updatedAt: DateTime.now(),
    );
    _mockDb[index] = updated;
    return Right(updated);
  }
}
```

- [ ] **Step 3: Register in DI**
Modify: `lib/core/di/injection_container.dart`
```dart
import '../../features/service/domain/repositories/service_repository.dart';
import '../../features/service/data/repositories/service_repository_impl.dart';
// ...
Future<void> init() async {
  // ...
  sl.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl());
}
```

---

### Task 3: Use Cases & BLoC Implementation

**Files:**
- Create: `lib/features/service/presentation/bloc/service_bloc.dart`

- [ ] **Step 1: Implement Service BLoC with Status Validation**
File: `lib/features/service/presentation/bloc/service_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/repositories/service_repository.dart';

// Events ... (FetchServices, AddServiceOrder, UpdateServiceStatus, etc.)
// States ... (ServiceLoading, ServiceLoaded, ServiceOperationSuccess, ServiceError)

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

    on<UpdateServiceStatus>((event, emit) async {
      // Basic validation: only move forward
      final currentOrder = (state as ServiceLoaded).services.firstWhere((o) => o.id == event.id);
      if (event.newStatus.index <= currentOrder.status.index) {
        emit(const ServiceError('Status can only move forward'));
        return;
      }

      final result = await repository.updateServiceStatus(event.id, event.newStatus);
      result.fold(
        (failure) => emit(const ServiceError('Update failed')),
        (_) => add(FetchServices()), // Reload list
      );
    });

    // Handle AddServiceOrder, AddServiceItem, RemoveServiceItem similarly...
  }
}
```

---

### Task 4: UI Development (Service List & Detail)

**Files:**
- Modify: `lib/features/service/presentation/pages/service_page.dart`
- Create: `lib/features/service/presentation/pages/service_detail_page.dart`

- [ ] **Step 1: Implement Service List View**
Update `service_page.dart` to use `BlocBuilder` and display a list of `ServiceOrder` cards.

- [ ] **Step 2: Implement Service Detail View**
Create a detailed page for a single `ServiceOrder` where users can manage items and update status.
