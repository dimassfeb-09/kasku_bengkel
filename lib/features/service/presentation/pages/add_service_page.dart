import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/service_bloc.dart';

class AddServicePage extends StatelessWidget {
  const AddServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ServiceBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Service'),
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
          child: const Center(
            child: Text('Add Service Page'),
          ),
        ),
      ),
    );
  }
}
