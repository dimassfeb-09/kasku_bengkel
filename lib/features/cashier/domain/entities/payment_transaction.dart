import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_method.dart';

part 'payment_transaction.freezed.dart';
part 'payment_transaction.g.dart';

@freezed
class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    required String serviceOrderId,
    required PaymentMethod paymentMethod,
    required double totalAmount,
    required double amountPaid,
    required double changeAmount,
    required DateTime transactionDate,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) => _$PaymentTransactionFromJson(json);
}
