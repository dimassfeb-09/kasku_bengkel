import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/service_bloc.dart';

class AddServiceItemPage extends StatelessWidget {
  final String orderId;

  const AddServiceItemPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ServiceBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Item Service'),
        ),
        body: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state) {
            if (state is ServiceOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.pop();
            } else if (state is ServiceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Center(
            child: Text('Add Service Item Page for Order ID: $orderId'),
          ),
        ),
      ),
    );
  }
}
