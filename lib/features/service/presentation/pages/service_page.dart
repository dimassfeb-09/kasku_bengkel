import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text('Manajemen Servis')),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiceLoaded) {
            if (state.services.isEmpty) {
              return const Center(child: Text('Belum ada antrian servis.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        child: const Icon(Icons.add),
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
        title: const Text('Tambah Servis Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: plateController,
                decoration: const InputDecoration(labelText: 'Plat Nomor'),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'No HP'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
              ),
              TextField(
                controller: complaintController,
                decoration: const InputDecoration(labelText: 'Keluhan'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newOrder = ServiceOrder(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                vehicleInfo: VehicleInfo(
                  plateNumber: plateController.text,
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
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _ServiceOrderCard extends StatelessWidget {
  final ServiceOrder order;

  const _ServiceOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.push('/services/${order.id}'),
        title: Text(
          order.vehicleInfo.plateNumber,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order.vehicleInfo.ownerName} - ${order.vehicleInfo.vehicleType}',
            ),
            const SizedBox(height: 4),
            _StatusBadge(status: order.status),
          ],
        ),
        trailing: Text(
          'Rp ${order.totalEstimation.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
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
        label = 'Antri';
        break;
      case ServiceStatus.dikerjakan:
        color = Colors.blue;
        label = 'Dikerjakan';
        break;
      case ServiceStatus.selesai:
        color = Colors.green;
        label = 'Selesai';
        break;
      case ServiceStatus.siapDiambil:
        color = Colors.teal;
        label = 'Siap Diambil';
        break;
      case ServiceStatus.lunas:
        color = Colors.grey;
        label = 'Lunas';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
