import 'package:flutter/material.dart';
import '../../../../core/ui/anim.dart';
import '../../../../core/ui/widgets.dart';
import '../../../../core/theme/app_theme.dart';

class UserWorkersPage extends StatefulWidget {
  final String initialJobdesk;
  const UserWorkersPage({super.key, required this.initialJobdesk});

  @override
  State<UserWorkersPage> createState() => _UserWorkersPageState();
}

class _UserWorkersPageState extends State<UserWorkersPage> {
  late String jobdesk;

  final jobs = const [
    "Perbaikan Kebocoran",
    "Installasi Pipa",
    "Pembersihan Saluran",
    "Perawatan Saluran",
  ];

  @override
  void initState() {
    super.initState();
    jobdesk = widget.initialJobdesk;
  }

  List<WorkerUi> get workers => [
    WorkerUi(
      name: "Rudi",
      jobdesk: jobdesk,
      rating: 4.9,
      jobs: 120,
      distance: "dekat",
      available: true,
    ),
    WorkerUi(
      name: "Dedi",
      jobdesk: jobdesk,
      rating: 4.6,
      jobs: 80,
      distance: "dekat",
      available: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageEnter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown putih seperti screenshot list worker
              Pressable(
                onTap: () async {
                  final picked = await showModalBottomSheet<String>(
                    context: context,
                    showDragHandle: true,
                    builder:
                        (_) => ListView(
                          children: [
                            for (final j in jobs)
                              ListTile(
                                title: Text(j),
                                onTap: () => Navigator.pop(context, j),
                              ),
                          ],
                        ),
                  );
                  if (picked != null) setState(() => jobdesk = picked);
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          jobdesk,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: ListView(
                  children: [
                    for (final w in workers)
                      WorkerCard(
                        w: w,
                        onTap: () {
                          // nanti bisa navigate ke booking/detail
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
