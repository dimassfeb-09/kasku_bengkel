import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cashier_bloc.dart';
import '../../domain/entities/payment_method.dart';
import '../../../service/domain/entities/service_order.dart';

class CheckoutDialog extends StatefulWidget {
  final ServiceOrder order;

  const CheckoutDialog({super.key, required this.order});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  PaymentMethod _selectedMethod = PaymentMethod.tunai;
  final _amountPaidController = TextEditingController();
  double _changeAmount = 0;

  @override
  void initState() {
    super.initState();
    _amountPaidController.addListener(_calculateChange);
  }

  void _calculateChange() {
    if (_selectedMethod != PaymentMethod.tunai) return;
    final paid = double.tryParse(_amountPaidController.text) ?? 0;
    setState(() {
      _changeAmount = paid - widget.order.totalEstimation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.order.totalEstimation;

    return AlertDialog(
      title: Text('Checkout: ${widget.order.vehicleInfo.plateNumber}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pemilik: ${widget.order.vehicleInfo.ownerName}'),
            const Divider(),
            ...widget.order.items.map((item) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.when(
                        labor: (name, _) => name,
                        part: (name, qty, _) => '$name (x$qty)',
                      )),
                    ),
                    Text('Rp ${item.subtotal.toStringAsFixed(0)}'),
                  ],
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Tagihan', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Rp ${total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<PaymentMethod>(
              isExpanded: true,
              value: _selectedMethod,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedMethod = val;
                    if (val != PaymentMethod.tunai) {
                      _amountPaidController.clear();
                      _changeAmount = 0;
                    }
                  });
                }
              },
              items: PaymentMethod.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name.toUpperCase())))
                  .toList(),
            ),
            if (_selectedMethod == PaymentMethod.tunai) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _amountPaidController,
                decoration: const InputDecoration(
                  labelText: 'Uang Diterima',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kembalian'),
                  Text(
                    'Rp ${_changeAmount < 0 ? 0 : _changeAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _changeAmount < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () {
            final paid = _selectedMethod == PaymentMethod.tunai
                ? double.tryParse(_amountPaidController.text)
                : total;

            if (_selectedMethod == PaymentMethod.tunai && (paid == null || paid < total)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pembayaran kurang!')),
              );
              return;
            }

            context.read<CashierBloc>().add(ProcessPayment(
                  serviceOrderId: widget.order.id,
                  method: _selectedMethod,
                  amountPaid: paid,
                ));
            Navigator.pop(context);
          },
          child: const Text('PROSES BAYAR'),
        ),
      ],
    );
  }
}
