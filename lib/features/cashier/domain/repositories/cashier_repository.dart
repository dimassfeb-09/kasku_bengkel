import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_transaction.dart';

abstract class CashierRepository {
  Future<Either<Failure, PaymentTransaction>> processPayment(PaymentTransaction transaction);
  Future<Either<Failure, List<PaymentTransaction>>> getTransactionHistory();
}
