import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  final VoidCallback onRegisterWorker;

  const UserProfilePage({
    super.key,
    required this.onEdit,
    required this.onLogout,
    required this.onRegisterWorker,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Address",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Banyumas, Jawa Tengah"),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "E-Mail",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("rahma@mail.com"),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Phone Number",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("0812xxxxxxx"),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onEdit,
              child: const Text("Edit Profile"),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onRegisterWorker,
              child: const Text("Daftar Sebagai Worker"),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onLogout,
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
