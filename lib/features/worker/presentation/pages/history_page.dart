import 'package:flutter/material.dart';
import '../../../../core/ui/widgets.dart';

class WorkerHistoryPage extends StatelessWidget {
  final VoidCallback onDetailIncome;
  const WorkerHistoryPage({super.key, required this.onDetailIncome});

  @override
  Widget build(BuildContext context) {
    final list = const [
      OrderUi(title: "Job #001", subtitle: "Status: Accepted", status: "Accepted"),
      OrderUi(title: "Job #002", subtitle: "Status: Reject", status: "Reject"),
      OrderUi(title: "Job #003", subtitle: "Status: Finished", status: "Finish"),
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        for (final o in list)
          OrderCard(
            o: o,
            onDetail: onDetailIncome,
          ),
      ],
    );
  }
}
