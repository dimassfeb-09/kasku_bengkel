import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/report_metrics.dart';
import '../../../service/domain/repositories/service_repository.dart';
import '../../../cashier/domain/repositories/cashier_repository.dart';
import '../../../service/domain/entities/service_status.dart';

// Events
abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

class LoadReports extends ReportsEvent {
  final DateTimeRange dateRange;
  const LoadReports(this.dateRange);
  @override
  List<Object?> get props => [dateRange];
}

// States
abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}
class ReportsLoading extends ReportsState {}
class ReportsLoaded extends ReportsState {
  final ReportMetrics metrics;
  final DateTimeRange dateRange;
  const ReportsLoaded(this.metrics, this.dateRange);
  @override
  List<Object?> get props => [metrics, dateRange];
}
class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
}

// Bloc
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ServiceRepository serviceRepository;
  final CashierRepository cashierRepository;

  ReportsBloc({
    required this.serviceRepository,
    required this.cashierRepository,
  }) : super(ReportsInitial()) {
    on<LoadReports>(_onLoadReports);
  }

  Future<void> _onLoadReports(LoadReports event, Emitter<ReportsState> emit) async {
    emit(ReportsLoading());

    final servicesResult = await serviceRepository.getActiveServices();
    final transactionsResult = await cashierRepository.getTransactionHistory();

    if (servicesResult.isLeft() || transactionsResult.isLeft()) {
      emit(const ReportsError('Gagal memuat data laporan'));
      return;
    }

    final allOrders = servicesResult.getOrElse(() => []);
    final allTransactions = transactionsResult.getOrElse(() => []);

    // Filter by Date Range
    final filteredOrders = allOrders.where((o) => 
      o.createdAt.isAfter(event.dateRange.start) && 
      o.createdAt.isBefore(event.dateRange.end.add(const Duration(days: 1)))
    ).toList();

    final filteredTransactions = allTransactions.where((t) => 
      t.transactionDate.isAfter(event.dateRange.start) && 
      t.transactionDate.isBefore(event.dateRange.end.add(const Duration(days: 1)))
    ).toList();

    // Calculations
    double revenue = filteredTransactions.fold(0, (sum, t) => sum + t.totalAmount);
    int count = filteredTransactions.length;
    double avg = count > 0 ? revenue / count : 0;

    // Top Services Ranking
    final serviceCounts = <String, int>{};
    for (final order in filteredOrders) {
      if (order.status == ServiceStatus.lunas) {
        for (final item in order.items) {
          item.maybeWhen(
            labor: (name, _) {
              serviceCounts[name] = (serviceCounts[name] ?? 0) + 1;
            },
            orElse: () {},
          );
        }
      }
    }

    final sortedServices = Map.fromEntries(
      serviceCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );

    emit(ReportsLoaded(
      ReportMetrics(
        revenue: revenue,
        transactionCount: count,
        averageValue: avg,
        topServices: sortedServices,
        filteredOrders: filteredOrders,
      ),
      event.dateRange,
    ));
  }
}
