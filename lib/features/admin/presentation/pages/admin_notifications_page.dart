import 'package:flutter/material.dart';

class AdminNotificationsPage extends StatelessWidget {
  final VoidCallback onOpenDetail;
  const AdminNotificationsPage({super.key, required this.onOpenDetail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Pendaftaran Worker: Rahma"),
            subtitle: const Text("Klik untuk lihat detail & portfolio"),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenDetail,
          ),
        ),
      ],
    );
  }
}
