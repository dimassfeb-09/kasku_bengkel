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
