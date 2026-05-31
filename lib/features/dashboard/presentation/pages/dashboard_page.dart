import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const LoadDashboardData());
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is DashboardLoaded) {
                final m = state.metrics;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Summary Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        SummaryCard(
                          title: 'Pendapatan Hari Ini',
                          value: 'Rp ${m.todayRevenue.toStringAsFixed(0)}',
                          icon: Icons.payments,
                          color: Colors.blue,
                        ),
                        SummaryCard(
                          title: 'Total Transaksi',
                          value: '${m.todayTransactionCount}',
                          icon: Icons.receipt_long,
                          color: Colors.teal,
                        ),
                        SummaryCard(
                          title: 'Antrian Aktif',
                          value: '${m.activeQueues}',
                          icon: Icons.engineering,
                          color: Colors.orange,
                        ),
                        SummaryCard(
                          title: 'Selesai & Siap',
                          value: '${m.completedVehicles}',
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. Chart Section
                    const Text(
                      'Pendapatan Mingguan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RevenueChart(weeklyRevenue: m.weeklyRevenue),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Quick Actions
                    const Text(
                      'Aksi Cepat',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _QuickActionButton(
                          label: 'Servis',
                          icon: Icons.add_circle_outline,
                          onTap: () => context.go('/services'),
                        ),
                        _QuickActionButton(
                          label: 'Kasir',
                          icon: Icons.point_of_sale,
                          onTap: () => context.go('/cashier'),
                        ),
                        _QuickActionButton(
                          label: 'Laporan',
                          icon: Icons.bar_chart,
                          onTap: () => context.go('/reports'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 4. Recent Services
                    const Text(
                      'Servis Terbaru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (m.recentServices.isEmpty)
                      const Center(child: Text('Belum ada data servis.'))
                    else
                      ...m.recentServices.map((s) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(s.vehicleInfo.plateNumber),
                              subtitle: Text(s.complaint),
                              trailing: Text(
                                s.status.name.toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                  ],
                );
              } else if (state is DashboardError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A)),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
