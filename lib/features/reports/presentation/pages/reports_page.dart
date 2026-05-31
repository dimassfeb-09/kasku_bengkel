import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_bloc.dart';
import '../../../../core/di/injection_container.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportsBloc>()
        ..add(
          LoadReports(
            DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now(),
            ),
          ),
        ),
      child: const ReportsView(),
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            final m = state.metrics;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateFilter(context, state.dateRange),
                  const SizedBox(height: 20),
                  _buildSummaryGrid(m),
                  const SizedBox(height: 24),
                  const Text(
                    'Top Jasa Servis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTopServices(m.topServices),
                  const SizedBox(height: 24),
                  const Text(
                    'Riwayat Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderHistory(m.filteredOrders),
                ],
              ),
            );
          } else if (state is ReportsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context, DateTimeRange currentRange) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A)),
        title: Text(
          '${currentRange.start.toString().split(' ')[0]} - ${currentRange.end.toString().split(' ')[0]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.edit),
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            initialDateRange: currentRange,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null && context.mounted) {
            context.read<ReportsBloc>().add(LoadReports(picked));
          }
        },
      ),
    );
  }

  Widget _buildSummaryGrid(dynamic m) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: [
        _MetricCard(
          'Pendapatan',
          'Rp ${m.revenue.toStringAsFixed(0)}',
          Colors.blue,
        ),
        _MetricCard('Transaksi', '${m.transactionCount}', Colors.teal),
        _MetricCard(
          'Rata-rata',
          'Rp ${m.averageValue.toStringAsFixed(0)}',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _MetricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTopServices(Map<String, int> services) {
    if (services.isEmpty) return const Text('Belum ada data jasa terlaris.');
    return Card(
      child: Column(
        children: services.entries
            .map(
              (e) => ListTile(
                title: Text(e.key),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${e.value}x',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOrderHistory(List<dynamic> orders) {
    if (orders.isEmpty)
      return const Text('Tidak ada riwayat order di periode ini.');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              o.vehicleInfo.plateNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${o.vehicleInfo.ownerName} - ${o.createdAt.toString().split(' ')[0]}',
            ),
            trailing: _StatusBadge(o.status.name),
          ),
        );
      },
    );
  }

  Widget _StatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.black54),
      ),
    );
  }
}
