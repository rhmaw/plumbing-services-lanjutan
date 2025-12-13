import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<AdminBloc>().add(LoadAdminProfileEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      // body: BlocBuilder<AdminBloc, AdminState>(
      //   builder: (context, state) {
      //     if (state is AdminProfileLoaded) {
      //       return Column(
      //         children: [
      //           const CircleAvatar(radius: 50),
      //           Text(state.admin.username),
      //           Text(state.admin.email),
      //           ElevatedButton(
      //             onPressed: () {
      //               context.read<AuthBloc>().add(LogoutEvent());
      //             },
      //             child: const Text('Logout'),
      //           ),
      //         ],
      //       );
      //     }
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
