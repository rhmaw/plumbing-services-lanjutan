import 'package:flutter/material.dart';

class TakeServicePage extends StatefulWidget {
  const TakeServicePage({super.key});

  @override
  State<TakeServicePage> createState() => _TakeServicePageState();
}

class _TakeServicePageState extends State<TakeServicePage> {
  int qtyPipe = 1;
  String difficulty = "Mudah";
  String status = "Accepted";

  int _price() {
    // sesuai PDF (contoh): mudah 40k, sedang 60k, sulit 80k
    final base = switch (difficulty) {
      "Mudah" => 40000,
      "Sedang" => 60000,
      _ => 80000,
    };
    return base * qtyPipe;
  }

  @override
  Widget build(BuildContext context) {
    final total = _price();

    return Scaffold(
      appBar: AppBar(title: const Text("Take Service")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Waktu: 12/12/2025 • 10:00"),
            const SizedBox(height: 10),
            const Text("Pekerja: Worker A"),
            const SizedBox(height: 14),

            Row(
              children: [
                const Expanded(child: Text("Jumlah pipa diperbaiki")),
                IconButton(onPressed: () => setState(() => qtyPipe = (qtyPipe - 1).clamp(1, 99)), icon: const Icon(Icons.remove_circle_outline)),
                Text("$qtyPipe", style: const TextStyle(fontWeight: FontWeight.w600)),
                IconButton(onPressed: () => setState(() => qtyPipe++), icon: const Icon(Icons.add_circle_outline)),
              ],
            ),

            const SizedBox(height: 14),
            DropdownButtonFormField(
              value: difficulty,
              items: const [
                DropdownMenuItem(value: "Mudah", child: Text("Tingkat mudah")),
                DropdownMenuItem(value: "Sedang", child: Text("Tingkat sedang")),
                DropdownMenuItem(value: "Sulit", child: Text("Tingkat sulit")),
              ],
              onChanged: (v) => setState(() => difficulty = v ?? difficulty),
            ),

            const SizedBox(height: 14),
            DropdownButtonFormField(
              value: status,
              items: const [
                DropdownMenuItem(value: "Accepted", child: Text("Accepted")),
                DropdownMenuItem(value: "Reject", child: Text("Reject")),
                DropdownMenuItem(value: "Finished", child: Text("Finished")),
              ],
              onChanged: (v) => setState(() => status = v ?? status),
            ),

            const SizedBox(height: 14),
            Text("Total Biaya: Rp$total", style: const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
