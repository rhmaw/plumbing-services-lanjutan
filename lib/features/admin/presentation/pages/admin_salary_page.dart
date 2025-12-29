import 'package:flutter/material.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/salary.dart';

class AdminSalaryPage extends StatelessWidget {
  final Salary salary;
  const AdminSalaryPage({super.key, required this.salary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Gaji')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            InfoRow(label: 'Total Jobs', value: salary.totalJobs.toString()),
            InfoRow(label: 'Total Income', value: salary.income.toString()),
            InfoRow(label: 'Admin Fee', value: salary.adminFee.toString()),
            const Divider(),
            InfoRow(
              label: 'Gaji Diterima',
              value: salary.workerSalary.toString(),
            ),
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
