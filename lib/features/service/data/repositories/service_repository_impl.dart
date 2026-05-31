import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/local_database.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final LocalDatabase dbProvider;

  ServiceRepositoryImpl({required this.dbProvider});

  @override
  Future<Either<Failure, List<ServiceOrder>>> getActiveServices() async {
    try {
      final db = await dbProvider.database;
      final result = await db.query('service_orders', orderBy: 'createdAt DESC');
      
      final orders = result.map((json) {
        // Handle conversion of nested items from string to list
        final Map<String, dynamic> mutableJson = Map<String, dynamic>.from(json);
        mutableJson['items'] = jsonDecode(json['items'] as String);
        
        // Structure VehicleInfo correctly from flat table
        mutableJson['vehicleInfo'] = {
          'plateNumber': json['plateNumber'],
          'ownerName': json['ownerName'],
          'ownerPhone': json['ownerPhone'],
          'vehicleType': json['vehicleType'],
          'vehicleBrand': json['vehicleBrand'],
          'vehicleModel': json['vehicleModel'],
        };
        
        return ServiceOrder.fromJson(mutableJson);
      }).toList();

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceOrder>> addServiceOrder(ServiceOrder order) async {
    try {
      final db = await dbProvider.database;
      final json = order.toJson();
      
      // Flatten vehicleInfo
      final Map<String, dynamic> row = {
        'id': json['id'],
        'plateNumber': order.vehicleInfo.plateNumber,
        'ownerName': order.vehicleInfo.ownerName,
        'ownerPhone': order.vehicleInfo.ownerPhone,
        'vehicleType': order.vehicleInfo.vehicleType,
        'vehicleBrand': order.vehicleInfo.vehicleBrand,
        'vehicleModel': order.vehicleInfo.vehicleModel,
        'complaint': json['complaint'],
        'mechanicName': json['mechanicName'],
        'status': json['status'],
        'items': jsonEncode(json['items']),
        'createdAt': json['createdAt'],
        'updatedAt': json['updatedAt'],
      };

      await db.insert('service_orders', row);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceOrder>> updateServiceStatus(String id, ServiceStatus newStatus) async {
    try {
      final db = await dbProvider.database;
      
      final Map<String, dynamic> values = {
        'status': newStatus.name,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (newStatus == ServiceStatus.selesai) {
        values['completedAt'] = DateTime.now().toIso8601String();
      } else if (newStatus == ServiceStatus.siapDiambil) {
        values['readyAt'] = DateTime.now().toIso8601String();
      }

      await db.update('service_orders', values, where: 'id = ?', whereArgs: [id]);
      
      // Return updated order (simplified)
      return getActiveServices().then((value) => value.fold(
        (l) => Left(l),
        (r) => Right(r.firstWhere((o) => o.id == id))
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceOrder>> addServiceItem(String id, ServiceItem item) async {
    try {
      final db = await dbProvider.database;
      final results = await db.query('service_orders', where: 'id = ?', whereArgs: [id]);
      if (results.isEmpty) return Left(ServerFailure());

      final currentItems = List<dynamic>.from(jsonDecode(results.first['items'] as String));
      currentItems.add(item.toJson());

      await db.update(
        'service_orders',
        {
          'items': jsonEncode(currentItems),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      return getActiveServices().then((value) => value.fold(
        (l) => Left(l),
        (r) => Right(r.firstWhere((o) => o.id == id))
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceOrder>> removeServiceItem(String id, int itemIndex) async {
    try {
      final db = await dbProvider.database;
      final results = await db.query('service_orders', where: 'id = ?', whereArgs: [id]);
      if (results.isEmpty) return Left(ServerFailure());

      final currentItems = List<dynamic>.from(jsonDecode(results.first['items'] as String));
      currentItems.removeAt(itemIndex);

      await db.update(
        'service_orders',
        {
          'items': jsonEncode(currentItems),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      return getActiveServices().then((value) => value.fold(
        (l) => Left(l),
        (r) => Right(r.firstWhere((o) => o.id == id))
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
