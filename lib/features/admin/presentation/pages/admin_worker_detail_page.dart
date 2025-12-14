import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_event.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_state.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/pages/admin_salary_page.dart';

class AdminWorkerDetailPage extends StatelessWidget {
  final String idRegistration;
  const AdminWorkerDetailPage({super.key, required this.idRegistration});

  @override
  Widget build(BuildContext context) {
    context.read<AdminBloc>().add(
      LoadWorkerDetailEvent(int.parse(idRegistration)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pekerja')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkerDetailLoaded) {
            final w = state.worker;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(radius: 50),
                  const SizedBox(height: 16),
                  Text(w.name, style: const TextStyle(fontSize: 22)),
                  InfoRow(label: 'Email', value: w.email),
                  InfoRow(label: 'Skill', value: w.skills),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AdminBloc>().add(
                              AcceptRegistrationEvent(
                                int.parse(idRegistration),
                              ),
                            );
                          },
                          child: const Text('Terima'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<AdminBloc>().add(
                              RejectRegistrationEvent(
                                int.parse(idRegistration),
                              ),
                            );
                          },
                          child: const Text('Tolak'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
