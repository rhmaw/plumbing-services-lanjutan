import 'package:flutter/material.dart';

class EditProfileWorkerPage extends StatefulWidget {
  const EditProfileWorkerPage({super.key});

  @override
  State<EditProfileWorkerPage> createState() => _EditProfileWorkerPageState();
}

class _EditProfileWorkerPageState extends State<EditProfileWorkerPage> {
  final name = TextEditingController(text: "Worker A");
  final email = TextEditingController(text: "worker@mail.com");
  final phone = TextEditingController(text: "0812xxxxxxx");
  final address = TextEditingController(text: "Banyumas");

  @override
  void dispose() { name.dispose(); email.dispose(); phone.dispose(); address.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile Worker")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(hintText: "Nama")),
            const SizedBox(height: 14),
            TextField(controller: email, decoration: const InputDecoration(hintText: "Email")),
            const SizedBox(height: 14),
            TextField(controller: phone, decoration: const InputDecoration(hintText: "No Telp")),
            const SizedBox(height: 14),
            TextField(controller: address, decoration: const InputDecoration(hintText: "Alamat")),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text("Save Changes"))),
          ],
        ),
      ),
    );
  }
}
