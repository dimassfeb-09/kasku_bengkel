import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF22C55E), size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'PAYMENT SUCCESS',
              style: GoogleFonts.firaSans(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            Text(
              'Transaksi berhasil dicatat',
              style: TextStyle(color: const Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Plat Nomor', order.vehicleInfo.plateNumber, isCode: true),
                  _buildSummaryRow('Pemilik', order.vehicleInfo.ownerName),
                  const Divider(height: 24),
                  _buildSummaryRow('Total Bill', 'Rp ${transaction.totalAmount.toStringAsFixed(0)}', isBold: true),
                  _buildSummaryRow('Metode', transaction.paymentMethod.name.toUpperCase()),
                  _buildSummaryRow('Bayar', 'Rp ${transaction.amountPaid.toStringAsFixed(0)}'),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Kembalian', 
                    'Rp ${transaction.changeAmount.toStringAsFixed(0)}', 
                    isBold: true, 
                    valueColor: const Color(0xFF166534)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // Future: PDF export
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: const Text('STRUK PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('SELESAI'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isCode = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          Text(
            value,
            style: isCode 
              ? GoogleFonts.firaCode(fontWeight: FontWeight.bold, fontSize: 13, color: valueColor ?? const Color(0xFF0F172A))
              : TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 14 : 13,
                  color: valueColor ?? const Color(0xFF0F172A),
                ),
          ),
        ],
      ),
    );
  }
}
