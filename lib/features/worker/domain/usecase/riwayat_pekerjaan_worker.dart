import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JobHistoryPage(),
    );
  }
}

class AppColors {
  static const primary = Color(0xFF6EA8FF); // biru header & button
  static const background = Color(0xFFF3F6FB); // bg abu
  static const card = Color(0xFFEAF1FF); // card biru muda
  static const finished = Color(0xFF4CAF50); // badge hijau
  static const textDark = Color(0xFF1E1E1E);
  static const textSoft = Color(0xFF6B7280);
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

class Job {
  final String name;
  final Salary salary;
  Job(this.name, this.salary);
}

class JobHistoryPage extends StatelessWidget {
  JobHistoryPage({super.key});

  final jobs = [
    Job(
      'Abdul Aziz',
      Salary(
        username: 'Banu',
        email: 'banu@gmail.com',
        workerId: 'ID-001',
        phone: '0854381659',
        address: 'Sempor',
        total: 1000000,
        admin: 100000,
      ),
    ),
    Job(
      'Saputra Dwi',
      Salary(
        username: 'Banu',
        email: 'banu@gmail.com',
        workerId: 'ID-002',
        phone: '0854381659',
        address: 'Sempor',
        total: 1000000,
        admin: 100000,
      ),
    ),
    Job(
      'Jiwa Sajiwo',
      Salary(
        username: 'Banu',
        email: 'banu@gmail.com',
        workerId: 'ID-003',
        phone: '0854381659',
        address: 'Sempor',
        total: 1000000,
        admin: 100000,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Riwayat Pekerjaan'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (_, i) {
          final job = jobs[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.finished,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Finished',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Review : Tidak ada review',
                    style: TextStyle(fontSize: 12)),
                const Text('Tanggal : 2025-06-29',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}