import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/cashier_repository.dart';

class CashierRepositoryImpl implements CashierRepository {
  final List<PaymentTransaction> _mockHistory = [];

  @override
  Future<Either<Failure, PaymentTransaction>> processPayment(PaymentTransaction transaction) async {
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _mockHistory.add(transaction);
    return Right(transaction);
  }

  @override
  Future<Either<Failure, List<PaymentTransaction>>> getTransactionHistory() async {
    return Right(List.unmodifiable(_mockHistory));
  }
}
