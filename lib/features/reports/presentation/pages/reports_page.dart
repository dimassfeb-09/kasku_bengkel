import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/reports_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/report_metrics.dart';
import '../../../service/domain/entities/service_status.dart';

import '../../../../core/utils/data_exporter.dart';

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'LAPORAN & ANALITIK',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            final m = state.metrics;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('PERIODE LAPORAN'),
                  const SizedBox(height: 12),
                  _buildDateFilterCard(context, state.dateRange),
                  const SizedBox(height: 28),
                  _buildSectionHeader('RINGKASAN FINANSIAL'),
                  const SizedBox(height: 12),
                  _buildSummaryGrid(m),
                  const SizedBox(height: 32),
                  _buildSectionHeader('TOP JASA SERVIS'),
                  const SizedBox(height: 12),
                  _buildTopServicesList(m.topServices),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('RIWAYAT AKTIVITAS'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.download_rounded,
                              size: 18,
                              color: Color(0xFF1E3A8A),
                            ),
                            onPressed: () async {
                              final path = await DataExporter.exportToExcel(
                                m.filteredOrders,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Berhasil ekspor ke: $path'),
                                  ),
                                );
                              }
                            },
                          ),
                          Text(
                            '${m.filteredOrders.length} Order',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildOrderHistoryList(m.filteredOrders),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.firaSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF64748B),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildDateFilterCard(
    BuildContext context,
    DateTimeRange currentRange,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.calendar_today_rounded,
          color: Color(0xFF1E3A8A),
          size: 20,
        ),
        title: Text(
          '${currentRange.start.toString().split(' ')[0]} — ${currentRange.end.toString().split(' ')[0]}',
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: const Color(0xFF1E293B),
          ),
        ),
        trailing: const Icon(
          Icons.tune_rounded,
          size: 20,
          color: Color(0xFF94A3B8),
        ),
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            initialDateRange: currentRange,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF1E3A8A),
                    onPrimary: Colors.white,
                    onSurface: Color(0xFF1E293B),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null && context.mounted) {
            context.read<ReportsBloc>().add(LoadReports(picked));
          }
        },
      ),
    );
  }

  Widget _buildSummaryGrid(ReportMetrics m) {
    return Row(
      children: [
        _MetricItem(
          label: 'Total Pendapatan',
          value: 'Rp ${m.revenue.toStringAsFixed(0)}',
          color: const Color(0xFF1E3A8A),
          flex: 4,
        ),
        const SizedBox(width: 12),
        _MetricItem(
          label: 'Transaksi',
          value: '${m.transactionCount}',
          color: const Color(0xFFF97316),
          flex: 2,
        ),
        const SizedBox(width: 12),
        _MetricItem(
          label: 'Rata-rata',
          value: 'Rp ${m.averageValue.toStringAsFixed(0)}',
          color: const Color(0xFF0F172A),
          flex: 3,
        ),
      ],
    );
  }

  Widget _buildTopServicesList(Map<String, int> services) {
    if (services.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Belum ada data jasa terlaris.'),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: services.entries
            .map(
              (e) => Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      e.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${e.value}x',
                        style: GoogleFonts.firaCode(
                          color: const Color(0xFF1E3A8A),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  if (e.key != services.keys.last)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOrderHistoryList(List<dynamic> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Tidak ada riwayat order.'),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            title: Text(
              o.vehicleInfo.plateNumber,
              style: GoogleFonts.firaCode(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              '${o.vehicleInfo.ownerName} • ${o.createdAt.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: _MiniStatusBadge(o.status),
          ),
        );
      },
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final int flex;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.firaCode(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatusBadge extends StatelessWidget {
  final ServiceStatus status;
  const _MiniStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toString().split('.').last.toUpperCase(),
        style: GoogleFonts.firaSans(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }
}
