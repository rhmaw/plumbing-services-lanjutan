import 'package:flutter/material.dart';

class WorkerIncomeDetailPage extends StatelessWidget {
  const WorkerIncomeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int total = 500000;
    final int cut = total * 10 ~/ 100; 
    final int receive = total - cut;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Gaji Worker")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Identitas Worker",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Nama: Worker A\nEmail: worker@mail.com\nNo Telp: 0812xxxxxxx\nAlamat: Banyumas",
            ),
            const SizedBox(height: 18),
            Text(
              "Total gaji: Rp$total",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "Potongan admin 10%: Rp$cut",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "Total diterima: Rp$receive",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Export Excel: implement pakai package excel / csv"),
                    ),
                  );
                },
                child: const Text("Export Excel"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}