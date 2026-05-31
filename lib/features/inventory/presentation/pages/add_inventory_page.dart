import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_bloc.dart';

class AddInventoryPage extends StatelessWidget {
  const AddInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<InventoryBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Inventaris'),
        ),
        body: BlocListener<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventoryOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.pop();
            } else if (state is InventoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Center(
            child: Text('Add Inventory Page'),
          ),
        ),
      ),
    );
  }
}
