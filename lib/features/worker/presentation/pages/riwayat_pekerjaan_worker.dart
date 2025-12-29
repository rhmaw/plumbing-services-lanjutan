import 'package:flutter/material.dart';
import 'detail_pemasukan_worker.dart';

class RiwayatPekerjaanWorkerPage extends StatelessWidget {
  const RiwayatPekerjaanWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = [
      Job(
        name: 'Abdul Aziz',
        salary: Salary(
          username: 'Abdul Aziz',
          email: 'abdul@gmail.com',
          workerId: 'ID-001',
          phone: '0854381659',
          address: 'Sempor',
          total: 1000000,
          admin: 100000,
        ),
      ),
      Job(
        name: 'Saputra Dwi',
        salary: Salary(
          username: 'Saputra Dwi',
          email: 'saputra@gmail.com',
          workerId: 'ID-002',
          phone: '0812987654',
          address: 'Gombong',
          total: 1200000,
          admin: 120000,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pekerjaan'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Status : Finished',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPemasukanWorkerPage(
                              salary: job.salary,
                            ),
                          ),
                        );
                      },
                      child: const Text('Detail'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =====================
/// MODEL (sementara di presentation)
/// =====================
class Job {
  final String name;
  final Salary salary;

  Job({required this.name, required this.salary});
}

class Salary {
  final String username;
  final String email;
  final String workerId;
  final String phone;
  final String address;
  final int total;
  final int admin;

  Salary({
    required this.username,
    required this.email,
    required this.workerId,
    required this.phone,
    required this.address,
    required this.total,
    required this.admin,
  });

  int get netto => total - admin;
}
