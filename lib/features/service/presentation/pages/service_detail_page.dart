import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/service_status.dart';
import '../../domain/entities/service_item.dart';
import '../bloc/service_bloc.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ServiceLoaded) {
          final order = state.services.firstWhere(
            (o) => o.id == serviceId,
            orElse: () => throw Exception('Service order not found'),
          );

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              title: Text(
                'WORK ORDER: ${order.vehicleInfo.plateNumber}',
                style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('INFORMASI KENDARAAN'),
                  const SizedBox(height: 12),
                  _buildVehicleInfoCard(order),
                  const SizedBox(height: 24),
                  _buildSectionHeader('KELUHAN PELANGGAN'),
                  const SizedBox(height: 12),
                  _buildComplaintCard(order.complaint),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('DAFTAR PEKERJAAN & PART'),
                      TextButton.icon(
                        onPressed: () => context.push('/services/$serviceId/add_item'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('TAMBAH'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (order.items.isEmpty)
                    _buildEmptyItemsState()
                  else
                    ...order.items.asMap().entries.map(
                      (entry) => _buildItemCard(
                        context,
                        serviceId,
                        entry.key,
                        entry.value,
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildEstimationSummary(order),
                  const SizedBox(height: 40),
                  _buildStatusActions(context, order),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Terjadi kesalahan')));
      },
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

  Widget _buildVehicleInfoCard(ServiceOrder order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildInfoColumn('Pemilik', order.vehicleInfo.ownerName, flex: 2),
              _buildInfoColumn(
                'Telepon',
                order.vehicleInfo.ownerPhone,
                flex: 3,
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              _buildInfoColumn('Jenis', order.vehicleInfo.vehicleType, flex: 2),
              _buildInfoColumn(
                'Model',
                '${order.vehicleInfo.vehicleBrand ?? ''} ${order.vehicleInfo.vehicleModel ?? ''}',
                flex: 3,
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn('Status', '', flex: 1),
              _StatusBadge(status: order.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.firaSans(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(String complaint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Text(
        complaint,
        style: const TextStyle(
          color: Color(0xFF9A3412),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Text(
          'Belum ada jasa atau sparepart ditambahkan',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    String id,
    int index,
    ServiceItem item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.when(
              labor: (name, price) => Icons.engineering_outlined,
              part: (name, qty, price) => Icons.settings_outlined,
            ),
            size: 20,
            color: const Color(0xFF64748B),
          ),
        ),
        title: Text(
          item.when(labor: (name, _) => name, part: (name, _, _) => name),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          item.when(
            labor: (_, price) => 'Jasa',
            part: (_, qty, price) => '$qty x Rp ${price.toStringAsFixed(0)}',
          ),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rp ${item.subtotal.toStringAsFixed(0)}',
              style: GoogleFonts.firaCode(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () =>
                  context.read<ServiceBloc>().add(RemoveServiceItem(id, index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimationSummary(ServiceOrder order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL ESTIMASI',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Text(
            'Rp ${order.totalEstimation.toStringAsFixed(0)}',
            style: GoogleFonts.firaCode(
              color: const Color(0xFFF97316),
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusActions(BuildContext context, ServiceOrder order) {
    if (order.status.toString().split('.').last == 'siapDiambil' ||
        order.status.toString().split('.').last == 'lunas') {
      return const SizedBox.shrink();
    }

    String label;
    ServiceStatus nextStatus;
    Color buttonColor;

    final currentStatus = order.status.toString().split('.').last;

    switch (currentStatus) {
      case 'antri':
        label = 'MULAI KERJAKAN';
        nextStatus = ServiceStatus.dikerjakan;
        buttonColor = const Color(0xFF1E3A8A);
        break;
      case 'dikerjakan':
        label = 'SELESAIKAN';
        nextStatus = ServiceStatus.selesai;
        buttonColor = const Color(0xFF1E3A8A);
        break;
      case 'selesai':
        label = 'KONFIRMASI SIAP DIAMBIL';
        nextStatus = ServiceStatus.siapDiambil;
        buttonColor = const Color(0xFFF97316);
        break;
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.read<ServiceBloc>().add(
            UpdateServiceStatus(order.id, nextStatus),
          );
        },
        child: Text(
          label,
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
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

    final currentStatus = status.toString().split('.').last;

    switch (currentStatus) {
      case 'antri':
        color = Colors.orange;
        label = 'ANTRI';
        break;
      case 'dikerjakan':
        color = Colors.blue;
        label = 'PROSES';
        break;
      case 'selesai':
        color = Colors.green;
        label = 'SELESAI';
        break;
      case 'siapDiambil':
        color = Colors.teal;
        label = 'SIAP';
        break;
      case 'lunas':
        color = const Color(0xFF64748B);
        label = 'LUNAS';
        break;
      default:
        color = Colors.grey;
        label = 'UNKNOWN';
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
