import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../../service/domain/repositories/service_repository.dart';
import '../../../cashier/domain/repositories/cashier_repository.dart';
import '../../../service/domain/entities/service_status.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final DashboardMetrics metrics;
  const DashboardLoaded(this.metrics);
  @override
  List<Object?> get props => [metrics];
}
class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ServiceRepository serviceRepository;
  final CashierRepository cashierRepository;

  DashboardBloc({
    required this.serviceRepository,
    required this.cashierRepository,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    
    final servicesResult = await serviceRepository.getActiveServices();
    final transactionsResult = await cashierRepository.getTransactionHistory();

    if (servicesResult.isLeft() || transactionsResult.isLeft()) {
      emit(const DashboardError('Failed to aggregate dashboard data'));
      return;
    }

    final services = servicesResult.getOrElse(() => []);
    final transactions = transactionsResult.getOrElse(() => []);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Today's Revenue & Transaction Count
    double todayRevenue = 0;
    int todayCount = 0;
    for (final tx in transactions) {
      final txDate = DateTime(tx.transactionDate.year, tx.transactionDate.month, tx.transactionDate.day);
      if (txDate.isAtSameMomentAs(today)) {
        todayRevenue += tx.totalAmount;
        todayCount++;
      }
    }

    // 2. Active Queues & Completed Vehicles
    int activeQueues = services.where((s) => 
      s.status == ServiceStatus.antri || s.status == ServiceStatus.dikerjakan
    ).length;

    int completedVehicles = services.where((s) => 
      s.status == ServiceStatus.selesai || s.status == ServiceStatus.siapDiambil
    ).length;

    // 3. Recent Active Services (Top 5)
    final recentServices = services
        .where((s) => s.status != ServiceStatus.lunas)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final topRecent = recentServices.take(5).toList();

    // 4. Weekly Revenue (Last 7 Days)
    List<double> weeklyRevenue = List.filled(7, 0.0);
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: 6 - i));
      for (final tx in transactions) {
        final txDate = DateTime(tx.transactionDate.year, tx.transactionDate.month, tx.transactionDate.day);
        if (txDate.isAtSameMomentAs(day)) {
          weeklyRevenue[i] += tx.totalAmount;
        }
      }
    }

    emit(DashboardLoaded(DashboardMetrics(
      todayRevenue: todayRevenue,
      todayTransactionCount: todayCount,
      activeQueues: activeQueues,
      completedVehicles: completedVehicles,
      recentServices: topRecent,
      weeklyRevenue: weeklyRevenue,
    )));
  }
}
