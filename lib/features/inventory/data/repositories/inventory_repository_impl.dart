import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/local_database.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final LocalDatabase dbProvider;

  InventoryRepositoryImpl({required this.dbProvider});

  @override
  Future<Either<Failure, List<InventoryItem>>> getAllItems() async {
    try {
      final db = await dbProvider.database;
      final result = await db.query('inventory', orderBy: 'name ASC');
      return Right(result.map((json) => InventoryItem.fromJson(json)).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> addItem(InventoryItem item) async {
    try {
      final db = await dbProvider.database;
      await db.insert('inventory', {
        ...item.toJson(),
        'type': item.type.toString().split('.').last,
        'createdAt': item.createdAt.toIso8601String(),
      });
      return Right(item);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> updateItem(InventoryItem item) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        'inventory',
        {...item.toJson(), 'type': item.type.toString().split('.').last},
        where: 'id = ?',
        whereArgs: [item.id],
      );
      return Right(item);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> adjustStock(String id, int delta) async {
    try {
      final db = await dbProvider.database;
      await db.rawUpdate(
        'UPDATE inventory SET stock = stock + ? WHERE id = ?',
        [delta, id],
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      final db = await dbProvider.database;
      await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
