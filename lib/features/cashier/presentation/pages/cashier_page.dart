import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Kasir / Transaksi')),
        body: BlocBuilder<CashierBloc, CashierState>(
          builder: (context, state) {
            if (state is CashierLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PendingPaymentsLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('Tidak ada order yang siap dibayar.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    child: ListTile(
                      title: Text(order.vehicleInfo.plateNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${order.vehicleInfo.ownerName} - ${order.vehicleInfo.vehicleType}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Rp ${order.totalEstimation.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          Text(order.status.name, style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
