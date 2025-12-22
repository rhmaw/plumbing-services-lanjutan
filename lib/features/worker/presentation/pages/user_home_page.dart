import 'package:flutter/material.dart';
import '../../../../core/ui/widgets.dart';

class UserHomePage extends StatefulWidget {
  final VoidCallback onOpenBooking;
  const UserHomePage({super.key, required this.onOpenBooking});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String jobdesk = "Installasi Pipa";

  final workers = const [
    WorkerUi(
      name: "Rudi",
      jobdesk: "Installasi Pipa",
      rating: 4.9,
      jobs: 120,
      distance: "dekat",
      available: true,
    ),
    WorkerUi(
      name: "Agus",
      jobdesk: "Pembersihan Saluran",
      rating: 4.7,
      jobs: 95,
      distance: "dekat",
      available: true,
    ),
    WorkerUi(
      name: "Bima",
      jobdesk: "Perawatan Saluran",
      rating: 4.8,
      jobs: 110,
      distance: "jauh",
      available: false,
    ),
    WorkerUi(
      name: "Dedi",
      jobdesk: "Installasi Pipa",
      rating: 4.6,
      jobs: 80,
      distance: "dekat",
      available: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = workers.where((w) => w.jobdesk == jobdesk).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Halo selamat datang Rahma",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: jobdesk,
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
            onChanged: (v) => setState(() => jobdesk = v ?? jobdesk),
          ),

          const SizedBox(height: 14),

          // grid: mobile 1 kolom, tablet 2, wide 4 (sesuai PDF)
          LayoutBuilder(
            builder: (_, c) {
              int cross = 1;
              if (c.maxWidth >= 900)
                cross = 4;
              else if (c.maxWidth >= 600)
                cross = 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: cross >= 4 ? 2.6 : 2.3,
                ),
                itemBuilder:
                    (_, i) =>
                        WorkerCard(w: filtered[i], onTap: widget.onOpenBooking),
              );
            },
          ),
        ],
      ),
    );
  }
}
