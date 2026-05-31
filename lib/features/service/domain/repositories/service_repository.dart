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
