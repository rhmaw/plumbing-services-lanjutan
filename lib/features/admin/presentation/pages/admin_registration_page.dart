import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_event.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_state.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/pages/admin_worker_detail_page.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadRegistrationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Data')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RegistrationLoaded) {
            final registrations = state.registrations;

            return ListView.builder(
              itemCount: registrations.length,
              itemBuilder: (context, index) {
                final reg = registrations[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(reg.name),
                    subtitle: Text(reg.email),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AdminWorkerDetailPage(
                                  idRegistration: reg.registrationId,
                                ),
                          ),
                        );
                      },
                      child: const Text('More Info'),
                    ),
                  ),
                );
              },
            );
          }

          if (state is AdminError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No Data'));
        },
      ),
    );
  }
}
