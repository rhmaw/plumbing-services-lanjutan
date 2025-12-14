import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_event.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_state.dart';

class AdminWorkerHistoryPage extends StatefulWidget {
  final String? workerId;

  const AdminWorkerHistoryPage({super.key, this.workerId});

  @override
  State<AdminWorkerHistoryPage> createState() => _AdminWorkerHistoryPageState();
}

class _AdminWorkerHistoryPageState extends State<AdminWorkerHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(
      LoadSalaryWorkerEvent(int.parse(widget.workerId.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pekerja')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is SalaryLoaded) {
            return Center(
              child: Text(
                'Total Gaji: Rp ${state.salary}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          }

          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
