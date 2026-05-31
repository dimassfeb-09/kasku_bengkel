import '../../../service/domain/entities/service_order.dart';

class DashboardMetrics {
  final double todayRevenue;
  final int todayTransactionCount;
  final int activeQueues;
  final int completedVehicles;
  final List<ServiceOrder> recentServices;
  final List<double> weeklyRevenue; // 7 days of totals

  const DashboardMetrics({
    required this.todayRevenue,
    required this.todayTransactionCount,
    required this.activeQueues,
    required this.completedVehicles,
    required this.recentServices,
    required this.weeklyRevenue,
  });
}
