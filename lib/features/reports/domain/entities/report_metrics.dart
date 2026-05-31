import '../../../service/domain/entities/service_order.dart';

class ReportMetrics {
  final double revenue;
  final int transactionCount;
  final double averageValue;
  final Map<String, int> topServices; // Service Name -> Count
  final List<ServiceOrder> filteredOrders;

  const ReportMetrics({
    required this.revenue,
    required this.transactionCount,
    required this.averageValue,
    required this.topServices,
    required this.filteredOrders,
  });

  factory ReportMetrics.empty() => const ReportMetrics(
        revenue: 0,
        transactionCount: 0,
        averageValue: 0,
        topServices: {},
        filteredOrders: [],
      );
}
