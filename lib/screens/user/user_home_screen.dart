import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../user/booking_screen.dart';
import '../../../../widget/user_bottom_nav.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Map<String, dynamic>> workers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  Future<void> _fetchWorkers() async {
    final url = Uri.parse('$apiBaseUrl/user/workers/available');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody.containsKey('data')) {
          print(responseBody['data']);
          setState(() {
            workers =
                responseBody['data']
                    .map<Map<String, dynamic>>(
                      (item) => {
                        'name': item['name'] ?? 'N/A',
                        'time': item['time'] ?? 'N/A',
                        'status': item['status'] ?? 'Available',
                      },
                    )
                    .toList();
          });
        } else {
          setState(() {
            workers = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data tidak ditemukan dalam respons.'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        // 🔹 Token tidak valid atau tidak diizinkan
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        final responseData = json.decode(response.body);
        String message = 'Autentikasi gagal';

        if (responseData.containsKey('message')) {
          message = responseData['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade700,
          ),
        );

        // 🔹 Worker tidak tersedia atau data kosong
      } else if (response.statusCode == 404) {
        final responseData = json.decode(response.body);
        String message = 'Belum ada worker tersedia saat ini.';

        if (responseData.containsKey('message')) {
          message = responseData['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.blueGrey),
        );

        setState(() {
          workers = [];
        });

        // 🔹 Server error atau validasi backend
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final responseData = json.decode(response.body);
        String message = 'Permintaan ditolak oleh server.';

        if (responseData.containsKey('message')) {
          message = responseData['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.orange),
        );

        setState(() {
          workers = [];
        });

        // 🔹 Server error internal
      } else if (response.statusCode >= 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Server mengalami kesalahan teknis. Silakan coba nanti.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Respons tidak diketahui dari server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kesalahan koneksi. Pastikan Anda terhubung ke internet.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _bookWorker(BuildContext context, int workerId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingScreen(workerId: workerId)),
    );
  }

  Future<String?> _getNameFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 0),
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _getNameFromPreferences(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text('Halo selamat datang ${snapshot.data}');
            } else {
              return const Text('Halo Selamat Datang');
            }
          },
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
                : ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    final workerId = index + 1; // Jika backend perlu ID worker
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    worker['name']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Shift: ${worker['time']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      () => _bookWorker(context, workerId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    textStyle: const TextStyle(fontSize: 14),
                                  ),
                                  child: const Text('Booking'),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  worker['status']!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
