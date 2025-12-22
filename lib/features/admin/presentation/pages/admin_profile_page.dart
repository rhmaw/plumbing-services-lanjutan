import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_event.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_state.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/auth_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/auth_event.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminBloc>().add(LoadAdminProfileEvent(int.parse('0')));

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminProfileLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 50),
                const SizedBox(height: 16),
                Text(state.admin.username),
                Text(state.admin.email),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
