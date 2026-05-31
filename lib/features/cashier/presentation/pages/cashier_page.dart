import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/cashier_bloc.dart';
import '../widgets/checkout_dialog.dart';
import '../widgets/payment_success_dialog.dart';
import '../../../../core/di/injection_container.dart';

class CashierPage extends StatelessWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CashierBloc>()..add(const LoadPendingPayments()),
      child: const CashierView(),
    );
  }
}

class CashierView extends StatelessWidget {
  const CashierView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CashierBloc, CashierState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => PaymentSuccessDialog(
              transaction: state.transaction,
              order: state.order,
            ),
          );
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            'KASIR & PEMBAYARAN',
            style: GoogleFonts.firaSans(fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<CashierBloc>().add(const LoadPendingPayments());
          },
          child: BlocBuilder<CashierBloc, CashierState>(
            builder: (context, state) {
              if (state is CashierLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PendingPaymentsLoaded) {
                if (state.orders.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return _PendingOrderCard(order: order);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fact_check_outlined, size: 64, color: const Color(0xFFCBD5E1)),
          const SizedBox(height: 16),
          Text(
            'Semua order aktif sudah dibayar',
            style: GoogleFonts.firaSans(color: const Color(0xFF64748B), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  final dynamic order; // ServiceOrder

  const _PendingOrderCard({required this.order});

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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          order.vehicleInfo.plateNumber,
          style: GoogleFonts.firaCode(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${order.vehicleInfo.ownerName} • ${order.vehicleInfo.vehicleType}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                order.status.toString().split('.').last.toUpperCase(),
                style: GoogleFonts.firaSans(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF475569)),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rp ${order.totalEstimation.toStringAsFixed(0)}',
              style: GoogleFonts.firaCode(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<CashierBloc>(),
              child: CheckoutDialog(order: order),
            ),
          );
        },
      ),
    );
  }
}
