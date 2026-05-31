import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/service_bloc.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../../../core/di/injection_container.dart';
import 'package:go_router/go_router.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServiceBloc>()..add(FetchServices()),
      child: const ServiceView(),
    );
  }
}

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ANTRIAN SERVIS',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiceLoaded) {
            if (state.services.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final order = state.services[index];
                return _ServiceOrderCard(order: order);
              },
            );
          } else if (state is ServiceError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddServiceDialog(context),
        label: Text(
          'Servis Baru',
          style: GoogleFonts.firaSans(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_task_rounded),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada antrian servis saat ini',
            style: GoogleFonts.firaSans(
              color: const Color(0xFF64748B),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final plateController = TextEditingController();
    final ownerController = TextEditingController();
    final phoneController = TextEditingController();
    final typeController = TextEditingController();
    final complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'TAMBAH SERVIS BARU',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                plateController,
                'Plat Nomor',
                Icons.badge_outlined,
              ),
              _buildTextField(
                ownerController,
                'Nama Pemilik',
                Icons.person_outline,
              ),
              _buildTextField(
                phoneController,
                'No HP',
                Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                typeController,
                'Jenis Kendaraan',
                Icons.directions_car_outlined,
              ),
              _buildTextField(
                complaintController,
                'Keluhan',
                Icons.report_problem_outlined,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'BATAL',
              style: TextStyle(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (plateController.text.isEmpty) return;
              final newOrder = ServiceOrder(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                vehicleInfo: VehicleInfo(
                  plateNumber: plateController.text.toUpperCase(),
                  ownerName: ownerController.text,
                  ownerPhone: phoneController.text,
                  vehicleType: typeController.text,
                ),
                complaint: complaintController.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              context.read<ServiceBloc>().add(AddServiceOrder(newOrder));
              Navigator.pop(dialogContext);
            },
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _ServiceOrderCard extends StatelessWidget {
  final ServiceOrder order;

  const _ServiceOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/services/${order.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.vehicleInfo.plateNumber,
                      style: GoogleFonts.firaCode(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${order.vehicleInfo.ownerName} • ${order.vehicleInfo.vehicleType}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.complaint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(
                      'Rp ${order.totalEstimation.toStringAsFixed(0)}',
                      style: GoogleFonts.firaCode(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ServiceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case ServiceStatus.antri:
        color = Colors.orange;
        label = 'ANTRI';
        break;
      case ServiceStatus.dikerjakan:
        color = Colors.blue;
        label = 'PROSES';
        break;
      case ServiceStatus.selesai:
        color = Colors.green;
        label = 'SELESAI';
        break;
      case ServiceStatus.siapDiambil:
        color = Colors.teal;
        label = 'SIAP';
        break;
      case ServiceStatus.lunas:
        color = const Color(0xFF64748B);
        label = 'LUNAS';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.firaSans(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
