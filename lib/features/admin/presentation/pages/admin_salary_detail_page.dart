import 'package:flutter/material.dart';

class AdminSalaryDetailPage extends StatelessWidget {
  const AdminSalaryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int total = 800000;
    final int cut = (total * 0.1).toInt();
    final int receive = total - cut;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Worker (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail pekerja lengkap",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Nama: Worker A\n"
              "Email: worker@mail.com\n"
              "No Telp: 0812xxxxxxx\n"
              "Alamat: Banyumas",
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
                      content: Text(
                        "Export Excel: implement di backend/Flutter",
                      ),
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
