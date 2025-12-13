import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: isWide ? 2 : 1,
            childAspectRatio: 3,
            children: const [
              _DashboardCard(title: 'Total Worker', value: '24'),
              _DashboardCard(title: 'Pending Registration', value: '5'),
              _DashboardCard(title: 'Total Income', value: 'Rp 12.000.000'),
              _DashboardCard(title: 'Admin Fee', value: 'Rp 1.200.000'),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const _DashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
