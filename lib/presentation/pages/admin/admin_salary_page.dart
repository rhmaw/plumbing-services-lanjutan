import 'package:flutter/material.dart';

class AdminSalaryScreen extends StatelessWidget {
  final String username;
  final String email;
  final String idWorker;
  final String noPhone;
  final String address;
  final String periode;
  final String totalSalary;
  final String adminDeduction10;
  final String totalReceived;

  const AdminSalaryScreen({
    super.key,
    required this.username,
    required this.email,
    required this.idWorker,
    required this.noPhone,
    required this.address,
    required this.periode,
    required this.totalSalary,
    required this.adminDeduction10,
    required this.totalReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Gaji Pekerja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profil
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(email, style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Informasi Gaji
            InfoRow(label: 'Username', value: username),
            InfoRow(label: 'Email', value: email),
            InfoRow(label: 'ID Worker', value: idWorker),
            InfoRow(label: 'No. Telepon', value: noPhone),
            InfoRow(label: 'Alamat', value: address),
            InfoRow(label: 'Periode', value: periode),
            InfoRow(label: 'Total Gaji', value: totalSalary),
            InfoRow(label: 'Potongan Admin (10%)', value: adminDeduction10),

            const Divider(height: 32, color: Colors.grey),

            // Total Diterima
            InfoRow(label: 'Total Diterima', value: totalReceived),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
