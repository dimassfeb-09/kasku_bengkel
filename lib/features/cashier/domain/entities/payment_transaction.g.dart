// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentTransactionImpl _$$PaymentTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentTransactionImpl(
  id: json['id'] as String,
  serviceOrderId: json['serviceOrderId'] as String,
  paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  amountPaid: (json['amountPaid'] as num).toDouble(),
  changeAmount: (json['changeAmount'] as num).toDouble(),
  transactionDate: DateTime.parse(json['transactionDate'] as String),
);

Map<String, dynamic> _$$PaymentTransactionImplToJson(
  _$PaymentTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'serviceOrderId': instance.serviceOrderId,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'totalAmount': instance.totalAmount,
  'amountPaid': instance.amountPaid,
  'changeAmount': instance.changeAmount,
  'transactionDate': instance.transactionDate.toIso8601String(),
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.tunai: 'tunai',
  PaymentMethod.transfer: 'transfer',
  PaymentMethod.qris: 'qris',
};
