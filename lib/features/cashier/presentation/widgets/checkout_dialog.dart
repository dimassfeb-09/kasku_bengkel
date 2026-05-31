import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void dispose() {
    _amountPaidController.dispose();
    super.dispose();
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'CHECKOUT: ${widget.order.vehicleInfo.plateNumber}',
        style: GoogleFonts.firaSans(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Tagihan',
              style: GoogleFonts.firaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: widget.order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.when(labor: (name, _) => name, part: (name, qty, _) => '$name (x$qty)'),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        'Rp ${item.subtotal.toStringAsFixed(0)}',
                        style: GoogleFonts.firaCode(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL TAGIHAN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                Text(
                  'Rp ${total.toStringAsFixed(0)}',
                  style: GoogleFonts.firaCode(
                    fontWeight: FontWeight.w900, 
                    fontSize: 20, 
                    color: const Color(0xFF1E3A8A)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'METODE PEMBAYARAN',
              style: GoogleFonts.firaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodSelector(),
            if (_selectedMethod == PaymentMethod.tunai) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _amountPaidController,
                autofocus: true,
                style: GoogleFonts.firaCode(fontWeight: FontWeight.bold, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Uang Diterima',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildChangeDisplay(),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('BATAL', style: TextStyle(color: Color(0xFF64748B))),
        ),
        SizedBox(
          width: 140,
          height: 48,
          child: ElevatedButton(
            onPressed: _onProsesBayar,
            child: const Text('BAYAR SEKARANG'),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMethod>(
          isExpanded: true,
          value: _selectedMethod,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
              .map((e) => DropdownMenuItem(
                  value: e, 
                  child: Text(e.toString().split('.').last.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChangeDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _changeAmount < 0 ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Kembalian',
            style: TextStyle(color: _changeAmount < 0 ? const Color(0xFF991B1B) : const Color(0xFF166534), fontSize: 13),
          ),
          Text(
            'Rp ${_changeAmount < 0 ? 0 : _changeAmount.toStringAsFixed(0)}',
            style: GoogleFonts.firaCode(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _changeAmount < 0 ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }

  void _onProsesBayar() {
    final total = widget.order.totalEstimation;
    final paid = _selectedMethod == PaymentMethod.tunai
        ? double.tryParse(_amountPaidController.text)
        : total;

    if (_selectedMethod == PaymentMethod.tunai && (paid == null || paid < total)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pembayaran kurang!'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<CashierBloc>().add(ProcessPayment(
          serviceOrderId: widget.order.id,
          method: _selectedMethod,
          amountPaid: paid,
        ));
    Navigator.pop(context);
  }
}
