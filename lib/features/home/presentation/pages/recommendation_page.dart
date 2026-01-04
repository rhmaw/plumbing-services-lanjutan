import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'booking_page.dart';

class RecommendationPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RecommendationPage({super.key, required this.userData});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List<dynamic> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://192.168.71.192:8080/api';
    return 'http://127.0.0.1:8080/api';
  }

  Future<void> _fetchRecommendations() async {
    final url = Uri.parse('${getBaseUrl()}/recommendations');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _recommendations = json['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error AI: $e");
      setState(() => _isLoading = false);
    }
  }

  void _navigateToBooking(String workerName, dynamic rating, dynamic jobs) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(
          userData: widget.userData,
          selectedWorkerName: workerName,
          workerRating: rating.toString(),
          workerJobs: jobs.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Rekomendasi AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6395F8),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.orange, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Smart Choice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Teknisi terbaik berdasarkan performa historis (Kualitas & Kecepatan).",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recommendations.isEmpty
                ? const Center(child: Text("Belum ada data rekomendasi."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _recommendations.length,
                    itemBuilder: (context, index) {
                      final worker = _recommendations[index];

                      Color rankColor = Colors.white;
                      Color borderColor = Colors.grey.shade300;
                      IconData? iconRank;

                      if (index == 0) {
                        rankColor = const Color(0xFFFFF9C4);
                        borderColor = const Color(0xFFFFD700);
                        iconRank = Icons.emoji_events;
                      } else if (index == 1) {
                        rankColor = const Color(0xFFEEEEEE);
                        borderColor = const Color(0xFFC0C0C0);
                      } else if (index == 2) {
                        rankColor = const Color(0xFFFFE0B2);
                        borderColor = const Color(0xFFCD7F32);
                      }

                      return Card(
                        elevation: 3,
                        color: rankColor,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: borderColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: iconRank != null
                                      ? Icon(
                                          iconRank,
                                          color: Colors.orange[800],
                                          size: 28,
                                        )
                                      : Text(
                                          "#${index + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      worker['username'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        Text(
                                          " ${worker['rating']}/5.0 ",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.work,
                                          color: Colors.blueGrey,
                                          size: 18,
                                        ),
                                        Text(" ${worker['jobs']} Jobs"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () => _navigateToBooking(
                                  worker['username'],
                                  worker['rating'],
                                  worker['jobs'],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6395F8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "Pilih",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
