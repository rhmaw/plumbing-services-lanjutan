import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';

class UserWorkersPage extends StatefulWidget {
  final DioClient client;
  const UserWorkersPage({super.key, required this.client});

  @override
  State<UserWorkersPage> createState() => _UserWorkersPageState();
}

class _UserWorkersPageState extends State<UserWorkersPage> {
  final TextEditingController _skillCtrl = TextEditingController();

  bool loading = true;
  List<dynamic> workers = [];
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    _skillCtrl.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final skill = _skillCtrl.text.trim();

      final res = await widget.client.dio.get(
        "/user/workers",
        queryParameters: {if (skill.isNotEmpty) "skill": skill},
      );

      final list =
          (res.data is Map && res.data["data"] is List)
              ? (res.data["data"] as List)
              : <dynamic>[];

      if (!mounted) return;
      setState(() {
        workers = list.toList();
        loading = false;
        error = null;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = "Gagal memuat data worker (${e.response?.statusCode ?? "-"})";
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = "Gagal memuat data worker";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose Service", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillCtrl,
                  decoration: const InputDecoration(
                    hintText: "Filter skill (contoh: Perbaikan Pipa)",
                  ),
                  onSubmitted: (_) => load(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(onPressed: load, child: const Text("Cari")),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (_, c) {
                final cross =
                    c.maxWidth >= 900 ? 4 : (c.maxWidth >= 600 ? 3 : 2);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: workers.length,
                  itemBuilder:
                      (_, i) => _WorkerCard(
                        w: workers[i],
                        onBook: () => _openBooking(workers[i]),
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openBooking(dynamic w) async {
    final jenis = TextEditingController();
    final date = TextEditingController(text: "2025-12-21");
    final time = TextEditingController(text: "10:00:00");

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text("Booking - ${w['name']}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: jenis,
                  decoration: const InputDecoration(hintText: "Jenis layanan"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    hintText: "Tanggal (YYYY-MM-DD)",
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: time,
                  decoration: const InputDecoration(
                    hintText: "Waktu (HH:MM:SS)",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Batal"),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await widget.client.dio.post(
                      "/user/book",
                      data: {
                        "id_worker": w["id_worker"],
                        "jenis_layanan":
                            jenis.text.trim().isEmpty
                                ? (w["skill"] ?? "Layanan")
                                : jenis.text.trim(),
                        "date": date.text.trim(),
                        "time": time.text.trim(),
                        "difficulty": "mudah",
                        "total_pembayaran": 0,
                      },
                    );

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Booking dibuat (pending)")),
                    );
                  } on DioException {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal booking")),
                    );
                  }
                },
                child: const Text("Booking"),
              ),
            ],
          );
        },
      );
    } finally {
      jenis.dispose();
      date.dispose();
      time.dispose();
    }
  }
}

class _WorkerCard extends StatelessWidget {
  final dynamic w;
  final VoidCallback onBook;
  const _WorkerCard({required this.w, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final rating = (w["avg_rating"] ?? 0).toString();
    final jobDone = (w["job_done"] ?? 0).toString();
    final name = (w["name"] ?? "W").toString();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "W";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 24, child: Text(initial)),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              (w["skill"] ?? "-").toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 4),
                Text(rating),
                const SizedBox(width: 10),
                const Icon(Icons.check_circle_outline, size: 16),
                const SizedBox(width: 4),
                Text(jobDone),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onBook,
                child: const Text("Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
