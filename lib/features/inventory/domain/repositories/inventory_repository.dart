import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getAllItems();
  Future<Either<Failure, InventoryItem>> addItem(InventoryItem item);
  Future<Either<Failure, InventoryItem>> updateItem(InventoryItem item);
  Future<Either<Failure, void>> adjustStock(String id, int delta);
  Future<Either<Failure, void>> deleteItem(String id);
}
