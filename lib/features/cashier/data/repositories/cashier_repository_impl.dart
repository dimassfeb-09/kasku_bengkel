import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/local_database.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/cashier_repository.dart';

class CashierRepositoryImpl implements CashierRepository {
  final LocalDatabase dbProvider;

  CashierRepositoryImpl({required this.dbProvider});

  @override
  Future<Either<Failure, PaymentTransaction>> processPayment(PaymentTransaction transaction) async {
    try {
      final db = await dbProvider.database;
      final row = {
        'id': transaction.id,
        'serviceOrderId': transaction.serviceOrderId,
        'paymentMethod': transaction.paymentMethod.name,
        'totalAmount': transaction.totalAmount,
        'amountPaid': transaction.amountPaid,
        'changeAmount': transaction.changeAmount,
        'transactionDate': transaction.transactionDate.toIso8601String(),
      };
      await db.insert('transactions', row);
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PaymentTransaction>>> getTransactionHistory() async {
    try {
      final db = await dbProvider.database;
      final result = await db.query('transactions', orderBy: 'transactionDate DESC');
      final list = result.map((json) => PaymentTransaction.fromJson(json)).toList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
