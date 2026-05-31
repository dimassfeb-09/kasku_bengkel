import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../bloc/inventory_bloc.dart';
import '../../domain/entities/inventory_item.dart';
import '../../../../core/di/injection_container.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InventoryBloc>()..add(const FetchInventory()),
      child: const InventoryView(),
    );
  }
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MANAJEMEN STOK', style: GoogleFonts.firaSans(fontWeight: FontWeight.w800)),
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('Katalog barang masih kosong.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.type == ItemType.part ? Colors.blue[50] : Colors.orange[50],
                      child: Icon(
                        item.type == ItemType.part ? Icons.settings_outlined : Icons.engineering_outlined,
                        color: item.type == ItemType.part ? Colors.blue : Colors.orange,
                        size: 20,
                      ),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Jual: Rp ${item.sellingPrice.toStringAsFixed(0)} • Beli: Rp ${item.purchasePrice.toStringAsFixed(0)}'),
                    trailing: item.type == ItemType.part 
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${item.stock}', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: item.stock <= item.minStockLevel ? Colors.red : Colors.green
                            )),
                            const Text('STOK', style: TextStyle(fontSize: 10)),
                          ],
                        )
                      : const Text('JASA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/add'),
        label: const Text('Tambah Barang'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
