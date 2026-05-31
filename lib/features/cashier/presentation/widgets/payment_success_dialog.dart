import 'package:flutter/material.dart';
import '../../../service/domain/entities/service_order.dart';
import '../../domain/entities/payment_transaction.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final PaymentTransaction transaction;
  final ServiceOrder order;

  const PaymentSuccessDialog({
    super.key,
    required this.transaction,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Pembayaran Berhasil'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('Plat Nomor', order.vehicleInfo.plateNumber),
            _buildInfoRow('Pemilik', order.vehicleInfo.ownerName),
            const Divider(),
            const Text('Rincian Layanan:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('- ${item.when(
                    labor: (name, _) => name,
                    part: (name, qty, _) => '$name (x$qty)',
                  )}'),
                )),
            const Divider(),
            _buildInfoRow('Total Bill', 'Rp ${transaction.totalAmount.toStringAsFixed(0)}'),
            _buildInfoRow('Metode', transaction.paymentMethod.name.toUpperCase()),
            _buildInfoRow('Bayar', 'Rp ${transaction.amountPaid.toStringAsFixed(0)}'),
            _buildInfoRow('Kembali', 'Rp ${transaction.changeAmount.toStringAsFixed(0)}', isBold: true),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${transaction.transactionDate.toString().split('.')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('SELESAI'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
