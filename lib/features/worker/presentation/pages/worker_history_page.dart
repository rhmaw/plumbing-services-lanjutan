import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../home/presentation/pages/worker_service_page.dart';
import '../../../profile/presentation/pages/worker_profile_page.dart';
import '../../../history/presentation/pages/worker_detail.dart';

class WorkerHistoryPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const WorkerHistoryPage({super.key, required this.userData});

  @override
  State<WorkerHistoryPage> createState() => _WorkerHistoryPageState();
}

class _WorkerHistoryPageState extends State<WorkerHistoryPage> {
  List<dynamic> _history = [];
  bool _isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // --- 1. CONFIG URL ---
  String getBaseUrl() {
    if (kIsWeb) return 'http://localhost:8080/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api';
    return 'http://127.0.0.1:8080/api';
  }

  Future<void> _fetchHistory() async {
    String workerId = widget.userData['id']?.toString() ?? '1';
    final url = Uri.parse('${getBaseUrl()}/booking/worker-history/$workerId');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _history = json['data'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkerServicePage(userData: widget.userData)));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkerProfilePage(userData: widget.userData)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: const Color(0xFF6495ED),
        title: const Text(
          "Riwayat Pekerjaan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false, 
        elevation: 0,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty 
              ? const Center(child: Text("Belum ada riwayat pekerjaan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return _buildExactCardImage72(item);
                  },
                ),
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF6495ED),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _onBottomNavTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExactCardImage72(Map<String, dynamic> item) {
    String name = item['customer_name'] ?? 'Pelanggan';
    String rawReview = item['review_comment'] ?? '';
    String reviewText = rawReview.isEmpty ? "Tidak ada review" : rawReview;
    
    String userId = item['user_id']?.toString() ?? '-';
    String date = item['booking_date'] ?? '2025-01-01';
    String bookingId = item['booking_id']?.toString() ?? '1';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFE3EEFD), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF81C784),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Finished",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildTextRow("Review : $reviewText"),
            const SizedBox(height: 4),
            _buildTextRow("ID User : $userId"),
            const SizedBox(height: 4),
            _buildTextRow("Tanggal : $date"),
            
            const SizedBox(height: 12),
            const Divider(color: Colors.black45, thickness: 0.5),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PemasukanDetailPage(
                          data: item, 
                          workerId: widget.userData['id'].toString()
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E60F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Text(
                    "Detail", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
                
                Text(
                  "Job ID : $bookingId",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13, 
        fontWeight: FontWeight.w500, 
        color: Colors.black87
      ),
    );
  }
}