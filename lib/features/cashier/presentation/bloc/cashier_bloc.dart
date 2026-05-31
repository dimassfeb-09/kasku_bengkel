import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/cashier_repository.dart';
import '../../../service/domain/entities/service_order.dart';
import '../../../service/domain/entities/service_status.dart';
import '../../../service/domain/repositories/service_repository.dart';

// Events
abstract class CashierEvent extends Equatable {
  const CashierEvent();
  @override
  List<Object?> get props => [];
}

class LoadPendingPayments extends CashierEvent {
  const LoadPendingPayments();
}

class ProcessPayment extends CashierEvent {
  final String serviceOrderId;
  final PaymentMethod method;
  final double? amountPaid;

  const ProcessPayment({
    required this.serviceOrderId,
    required this.method,
    this.amountPaid,
  });

  @override
  List<Object?> get props => [serviceOrderId, method, amountPaid];
}

// States
abstract class CashierState extends Equatable {
  const CashierState();
  @override
  List<Object?> get props => [];
}

class CashierInitial extends CashierState {}

class CashierLoading extends CashierState {}

class PendingPaymentsLoaded extends CashierState {
  final List<ServiceOrder> orders;
  const PendingPaymentsLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class PaymentSuccess extends CashierState {
  final PaymentTransaction transaction;
  final ServiceOrder order;
  const PaymentSuccess(this.transaction, this.order);
  @override
  List<Object?> get props => [transaction, order];
}

class PaymentError extends CashierState {
  final String message;
  const PaymentError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class CashierBloc extends Bloc<CashierEvent, CashierState> {
  final CashierRepository cashierRepository;
  final ServiceRepository serviceRepository;

  CashierBloc({
    required this.cashierRepository,
    required this.serviceRepository,
  }) : super(CashierInitial()) {
    on<LoadPendingPayments>(_onLoadPendingPayments);
    on<ProcessPayment>(_onProcessPayment);
  }

  Future<void> _onLoadPendingPayments(
    LoadPendingPayments event,
    Emitter<CashierState> emit,
  ) async {
    emit(CashierLoading());
    final result = await serviceRepository.getActiveServices();
    result.fold(
      (failure) => emit(const PaymentError('Failed to load services')),
      (services) {
        final pending = services
            .where((s) =>
                s.status.toString().split('.').last == 'selesai' ||
                s.status.toString().split('.').last == 'siapDiambil')
            .toList();
        emit(PendingPaymentsLoaded(pending));
      },
    );
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<CashierState> emit,
  ) async {
    emit(CashierLoading());

    // 1. Fetch Order
    final servicesResult = await serviceRepository.getActiveServices();
    final serviceOrder = servicesResult.fold(
      (_) => null,
      (services) => services.firstWhere((s) => s.id == event.serviceOrderId),
    );

    if (serviceOrder == null) {
      emit(const PaymentError('Order not found'));
      return;
    }

    // 2. Double Payment Validation
    if (serviceOrder.status == ServiceStatus.lunas) {
      emit(const PaymentError('Order is already paid'));
      return;
    }

    // 3. Logic & Math
    final totalAmount = serviceOrder.totalEstimation;
    double amountPaid;
    double changeAmount;

    if (event.method == PaymentMethod.tunai) {
      if (event.amountPaid == null || event.amountPaid! < totalAmount) {
        emit(const PaymentError('Insufficient payment amount'));
        return;
      }
      amountPaid = event.amountPaid!;
      changeAmount = amountPaid - totalAmount;
    } else {
      amountPaid = totalAmount;
      changeAmount = 0;
    }

    // 4. Create Transaction
    final transaction = PaymentTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      serviceOrderId: event.serviceOrderId,
      paymentMethod: event.method,
      totalAmount: totalAmount,
      amountPaid: amountPaid,
      changeAmount: changeAmount,
      transactionDate: DateTime.now(),
    );

    // 5. Save Transaction
    final payResult = await cashierRepository.processPayment(transaction);
    if (payResult.isLeft()) {
      emit(const PaymentError('Failed to record transaction'));
      return;
    }

    // 6. Update Service Status
    final statusResult = await serviceRepository.updateServiceStatus(
      event.serviceOrderId,
      ServiceStatus.lunas,
    );

    if (statusResult.isLeft()) {
      emit(const PaymentError('Failed to update service status'));
      return;
    }

    // 7. Success
    emit(PaymentSuccess(transaction, serviceOrder));
    
    // Refresh list
    add(const LoadPendingPayments());
  }
}
