import 'package:flutter/material.dart';
import '../../../../core/ui/widgets.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> with TickerProviderStateMixin {
  late final tab = TabController(length: 3, vsync: this);

  final pending = const [
    OrderUi(title: "Rudi • Installasi Pipa", subtitle: "Menunggu diterima worker", status: "Pending"),
  ];
  final accepted = const [
    OrderUi(title: "Agus • Pembersihan Saluran", subtitle: "Diterima • Proses pengerjaan", status: "Accepted"),
  ];
  final finish = const [
    OrderUi(title: "Bima • Perawatan Saluran", subtitle: "Selesai • Silakan beri review", status: "Finish"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tab,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Accepted"),
            Tab(text: "Finish"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tab,
            children: [
              _List(orders: pending, reviewOnFinish: false),
              _List(orders: accepted, reviewOnFinish: false),
              _List(orders: finish, reviewOnFinish: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _List extends StatelessWidget {
  final List<OrderUi> orders;
  final bool reviewOnFinish;
  const _List({required this.orders, required this.reviewOnFinish});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text("Kosong"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: orders.length,
      itemBuilder: (_, i) => OrderCard(
        o: orders[i],
        onReview: reviewOnFinish
            ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewPage()))
            : null,
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int star = 5;
  final ctrl = TextEditingController();

  @override
  void dispose() { ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Penilaian rating (bintang)", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (i) {
                final filled = i < star;
                return IconButton(
                  onPressed: () => setState(() => star = i + 1),
                  icon: Icon(filled ? Icons.star : Icons.star_border),
                );
              }),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: const InputDecoration(hintText: "Ulasan"),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Send"),
              ),
            )
          ],
        ),
      ),
    );
  }
}