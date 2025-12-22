import 'package:flutter/material.dart';
import 'riwayat_pekerjaan_worker.dart';

class DetailPemasukanWorkerPage extends StatelessWidget {
  final Salary salary;

  const DetailPemasukanWorkerPage({
    super.key,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemasukan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identitas Worker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nama : ${salary.username}'),
            Text('Email : ${salary.email}'),
            Text('Worker ID : ${salary.workerId}'),
            Text('No Telp : ${salary.phone}'),
            Text('Alamat : ${salary.address}'),

            const Divider(height: 30),

            Text('Total Gaji : Rp${salary.total}'),
            Text('Potongan Admin : Rp${salary.admin}'),
            Text('Total Diterima : Rp${salary.netto}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Export laporan (Excel / PDF)',
                      ),
                    ),
                  );
                },
                child: const Text('Export Laporan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
