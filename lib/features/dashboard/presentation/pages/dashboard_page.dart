import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/summary_card.dart';
import '../widgets/revenue_chart.dart';
import '../../../../core/di/injection_container.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(const LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KASIRKU BENGKEL',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: const Color(0xFF1E293B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const LoadDashboardData());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              final m = state.metrics;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Hari Ini',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        SummaryCard(
                          title: 'Pendapatan',
                          value: 'Rp ${m.todayRevenue.toStringAsFixed(0)}',
                          icon: Icons.account_balance_wallet_outlined,
                          color: const Color(0xFF64748B),
                        ),
                        SummaryCard(
                          title: 'Transaksi',
                          value: '${m.todayTransactionCount}',
                          icon: Icons.receipt_outlined,
                          color: const Color(0xFFF97316),
                        ),
                        SummaryCard(
                          title: 'Antrian',
                          value: '${m.activeQueues}',
                          icon: Icons.precision_manufacturing_outlined,
                          color: const Color(0xFF64748B),
                        ),
                        SummaryCard(
                          title: 'Selesai',
                          value: '${m.completedVehicles}',
                          icon: Icons.verified_outlined,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Performa Mingguan',
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          '7 Hari Terakhir',
                          style: GoogleFonts.firaSans(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: RevenueChart(weeklyRevenue: m.weeklyRevenue),
                    ),
                    const SizedBox(height: 32),

                    Text('Aksi Cepat', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _QuickActionIcon(
                          label: 'Servis',
                          icon: Icons.add_task_rounded,
                          onTap: () => context.go('/services'),
                        ),
                        const SizedBox(width: 16),
                        _QuickActionIcon(
                          label: 'Kasir',
                          icon: Icons.point_of_sale_rounded,
                          onTap: () => context.go('/cashier'),
                        ),
                        const SizedBox(width: 16),
                        _QuickActionIcon(
                          label: 'Laporan',
                          icon: Icons.analytics_outlined,
                          onTap: () => context.go('/reports'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Servis Terbaru',
                          style: theme.textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () => context.go('/services'),
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (m.recentServices.isEmpty)
                      _buildEmptyState()
                    else
                      ...m.recentServices.map(
                        (s) => _buildRecentServiceCard(s),
                      ),
                  ],
                ),
              );
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: BorderStyle.none,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          Text(
            'Belum ada aktivitas servis',
            style: GoogleFonts.firaSans(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentServiceCard(dynamic s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(
            s.vehicleInfo.vehicleType.toLowerCase().contains('motor')
                ? Icons.motorcycle_outlined
                : Icons.directions_car_filled_outlined,
            color: const Color(0xFF64748B),
            size: 20,
          ),
        ),
        title: Text(
          s.vehicleInfo.plateNumber,
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${s.vehicleInfo.ownerName} • ${s.complaint}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            s.status.toString().split('.').last.toUpperCase(),
            style: GoogleFonts.firaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionIcon({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFFF97316), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.firaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
