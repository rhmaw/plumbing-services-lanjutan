import 'package:flutter/material.dart';

class RegisterWorkerFormPage extends StatefulWidget {
  const RegisterWorkerFormPage({super.key});

  @override
  State<RegisterWorkerFormPage> createState() => _RegisterWorkerFormPageState();
}

class _RegisterWorkerFormPageState extends State<RegisterWorkerFormPage> {
  final username = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final address = TextEditingController();
  final otherSkill = TextEditingController();
  final portfolio = TextEditingController();

  String gender = "Laki-laki";
  String skill = "Installasi Pipa";

  @override
  void dispose() {
    username.dispose();
    phone.dispose();
    email.dispose();
    pass.dispose();
    address.dispose();
    otherSkill.dispose();
    portfolio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Pendaftaran Worker")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(hintText: "Username"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phone,
              decoration: const InputDecoration(hintText: "Phone number"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: address,
              decoration: const InputDecoration(hintText: "Address"),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField(
              value: gender,
              items: const [
                DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
                DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
              ],
              onChanged: (v) => setState(() => gender = v ?? gender),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField(
              value: skill,
              items: const [
                DropdownMenuItem(
                  value: "Installasi Pipa",
                  child: Text("Installasi Pipa"),
                ),
                DropdownMenuItem(
                  value: "Pembersihan Saluran",
                  child: Text("Pembersihan Saluran"),
                ),
                DropdownMenuItem(
                  value: "Perawatan Saluran",
                  child: Text("Perawatan Saluran"),
                ),
              ],
              onChanged: (v) => setState(() => skill = v ?? skill),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: otherSkill,
              decoration: const InputDecoration(hintText: "Other Skill"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: portfolio,
              decoration: const InputDecoration(hintText: "Link Portfolio"),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
