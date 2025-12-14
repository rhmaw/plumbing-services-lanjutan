import 'package:flutter/material.dart';

class HistoryRatingPage extends StatefulWidget {
  const HistoryRatingPage({super.key});

  @override
  State<HistoryRatingPage> createState() => _HistoryRatingPageState();
}

class _HistoryRatingPageState extends State<HistoryRatingPage> {
  int selectedTab = 2; // 0 = Pending, 1 = Accepted, 2 = Finish

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _title(isTablet),
              const SizedBox(height: 16),
              _tabMenu(isTablet),
              const SizedBox(height: 16),
              Expanded(child: _content()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(bool isTablet) {
    return Text(
      'Order History',
      style: TextStyle(
        fontSize: isTablet ? 26 : 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _tabMenu(bool isTablet) {
    return Container(
      height: isTablet ? 52 : 44,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final labels = ['Pending', 'Accepted', 'Finish'];

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      selectedTab == index ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == index ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _content() {
    if (selectedTab != 2) {
      return _emptyState();
    }

    return ListView(
      children: const [
        HistoryRatingCard(),
        SizedBox(height: 12),
        HistoryRatingCard(),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Belum ada riwayat Finish',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class HistoryRatingCard extends StatelessWidget {
  const HistoryRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(isTablet),
          const SizedBox(height: 12),
          _detail('Tanggal', '2025-11-29', isTablet),
          _detail('Waktu', '15:45:49', isTablet),
          _detail('Job ID', '1', isTablet),
          _detail('Layanan', 'Ganti Pipa', isTablet),
          _detail('Jumlah Pipa Diperbaiki', '3', isTablet),
          _detail('Kesulitan', 'Mudah', isTablet),
          _detail('Total Biaya', '150.000', isTablet),
          const SizedBox(height: 12),
          _ratingStars(4, isTablet),
          const SizedBox(height: 12),
          _reviewBox(context, isTablet),
        ],
      ),
    );
  }

  Widget _header(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Worker Name : Banu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Finished',
            style: TextStyle(color: Colors.white, fontSize: isTablet ? 13 : 12),
          ),
        ),
      ],
    );
  }

  Widget _detail(String title, String value, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$title : $value',
        style: TextStyle(fontSize: isTablet ? 15 : 13),
      ),
    );
  }

  Widget _ratingStars(int rating, bool isTablet) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: isTablet ? 26 : 22,
        );
      }),
    );
  }

  Widget _reviewBox(BuildContext context, bool isTablet) {
    return GestureDetector(
      onTap: () => _showReviewDialog(context, isTablet),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 14 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Ulasan : Sangat bagus, dalam pengerjaan...',
          style: TextStyle(color: Colors.grey, fontSize: isTablet ? 14 : 13),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Suka dengan layanan kami?\nBerikan penilaian',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isTablet ? 18 : 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: isTablet ? 30 : 26,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tulis ulasan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kirim'),
              ),
            ],
          ),
    );
  }
}
