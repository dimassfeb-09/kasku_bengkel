import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            appBar: AppBar(
              title: Text('Detail Servis: ${order.vehicleInfo.plateNumber}'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleInfo(order),
                  const Divider(height: 32),
                  const Text(
                    'Keluhan:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(order.complaint),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Pekerjaan & Part:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () => _showAddItemDialog(context, serviceId),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...order.items.asMap().entries.map(
                    (entry) => _buildItemCard(
                      context,
                      serviceId,
                      entry.key,
                      entry.value,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimasi:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Rp ${order.totalEstimation.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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

  Widget _buildVehicleInfo(ServiceOrder order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemilik: ${order.vehicleInfo.ownerName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Telepon: ${order.vehicleInfo.ownerPhone}'),
            Text(
              'Kendaraan: ${order.vehicleInfo.vehicleBrand} ${order.vehicleInfo.vehicleModel} (${order.vehicleInfo.vehicleType})',
            ),
            const SizedBox(height: 8),
            _buildStatusBadge(order.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ServiceStatus status) {
    Color color;
    String text;
    switch (status) {
      case ServiceStatus.antri:
        color = Colors.grey;
        text = 'ANTRI';
        break;
      case ServiceStatus.dikerjakan:
        color = Colors.orange;
        text = 'DIKERJAKAN';
        break;
      case ServiceStatus.selesai:
        color = Colors.blue;
        text = 'SELESAI';
        break;
      case ServiceStatus.siapDiambil:
        color = Colors.green;
        text = 'SIAP DIAMBIL';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          item.when(labor: (name, _) => name, part: (name, _, _) => name),
        ),
        subtitle: Text(
          item.when(
            labor: (_, price) => 'Jasa - Rp ${price.toStringAsFixed(0)}',
            part: (_, qty, price) =>
                'Part - $qty x Rp ${price.toStringAsFixed(0)}',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rp ${item.subtotal.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<ServiceBloc>().add(RemoveServiceItem(id, index));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusActions(BuildContext context, ServiceOrder order) {
    if (order.status == ServiceStatus.siapDiambil)
      return const SizedBox.shrink();

    String label;
    ServiceStatus nextStatus;

    switch (order.status) {
      case ServiceStatus.antri:
        label = 'Mulai Kerjakan';
        nextStatus = ServiceStatus.dikerjakan;
        break;
      case ServiceStatus.dikerjakan:
        label = 'Selesaikan';
        nextStatus = ServiceStatus.selesai;
        break;
      case ServiceStatus.selesai:
        label = 'Siap Diambil';
        nextStatus = ServiceStatus.siapDiambil;
        break;
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<ServiceBloc>().add(
            UpdateServiceStatus(order.id, nextStatus),
          );
        },
        child: Text(label),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        double price = 0;
        int qty = 1;
        bool isLabor = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Jasa'),
                        selected: isLabor,
                        onSelected: (val) => setState(() => isLabor = true),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Part'),
                        selected: !isLabor,
                        onSelected: (val) => setState(() => isLabor = false),
                      ),
                    ],
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nama'),
                    onChanged: (val) => name = val,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => price = double.tryParse(val) ?? 0,
                  ),
                  if (!isLabor)
                    TextField(
                      decoration: const InputDecoration(labelText: 'Kuantitas'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => qty = int.tryParse(val) ?? 1,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final item = isLabor
                        ? ServiceItem.labor(name: name, price: price)
                        : ServiceItem.part(
                            name: name,
                            quantity: qty,
                            unitPrice: price,
                          );
                    context.read<ServiceBloc>().add(AddServiceItem(id, item));
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
