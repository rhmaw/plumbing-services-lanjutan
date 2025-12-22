import 'package:flutter/material.dart';

class WorkerProfilePage extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  const WorkerProfilePage({super.key, required this.onEdit, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.engineering, size: 42)),
          const SizedBox(height: 14),
          const Align(alignment: Alignment.centerLeft, child: Text("Address", style: TextStyle(fontWeight: FontWeight.w600))),
          const Align(alignment: Alignment.centerLeft, child: Text("Banyumas")),
          const SizedBox(height: 10),
          const Align(alignment: Alignment.centerLeft, child: Text("E-Mail", style: TextStyle(fontWeight: FontWeight.w600))),
          const Align(alignment: Alignment.centerLeft, child: Text("worker@mail.com")),
          const SizedBox(height: 10),
          const Align(alignment: Alignment.centerLeft, child: Text("Phone", style: TextStyle(fontWeight: FontWeight.w600))),
          const Align(alignment: Alignment.centerLeft, child: Text("0812xxxxxxx")),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: onEdit, child: const Text("Edit Profile"))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: onLogout, child: const Text("Logout"))),
        ],
      ),
    );
  }
}
