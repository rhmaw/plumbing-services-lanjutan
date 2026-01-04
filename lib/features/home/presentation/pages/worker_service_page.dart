import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../history/presentation/pages/worker_history_page.dart';
import '../../../profile/presentation/pages/worker_profile_page.dart';
import 'take_service_page.dart';

class WorkerServicePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const WorkerServicePage({super.key, required this.userData});

  @override
  State<WorkerServicePage> createState() => _WorkerServicePageState();
}

class _WorkerServicePageState extends State<WorkerServicePage> {
  List<dynamic> _pendingJobs = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPendingJobs();
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.126.120.69:8080/api';
    return 'http://127.0.0.1:8080/api';
  }

  Future<void> _fetchPendingJobs() async {
    String workerName = widget.userData['username'] ?? '';
    final url = Uri.parse('${getBaseUrl()}/booking/worker-pending/${Uri.encodeComponent(workerName)}');
    
    try {
      final response = await http.get(url, headers: {"Accept": "application/json"});
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _pendingJobs = json['data'] ?? [];
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
    if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
        WorkerHistoryPage(userData: widget.userData) 
      ));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
        WorkerProfilePage(userData: widget.userData)
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String workerName = widget.userData['username'] ?? 'Worker';

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: const Color(0xFF6495ED), 
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Halo selamat datang $workerName ",
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
            ),
            const Icon(Icons.account_circle, color: Colors.white, size: 24),
          ],
        ),
        centerTitle: true,
      ),

      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _pendingJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off_outlined, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("Belum ada orderan masuk.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingJobs.length,
              itemBuilder: (context, index) {
                return _buildJobCardExact77(_pendingJobs[index]);
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCardExact77(Map<String, dynamic> job) {
    String customerName = job['customer_name'] ?? 'User';
    String time = job['booking_time'] ?? '-';
    String address = job['customer_address'] ?? 'null';
    String phone = job['customer_phone'] ?? '-';
    String photoUrl = job['customer_photo'] ?? ''; 
    
    int bookingId = int.tryParse(job['id'].toString()) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEFD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 35, 
                backgroundColor: Colors.grey[300],
                backgroundImage: (photoUrl.isNotEmpty && photoUrl != 'null') 
                  ? NetworkImage(photoUrl) 
                  : const AssetImage('assets/images/user_placeholder.png') as ImageProvider,
                child: (photoUrl.isEmpty || photoUrl == 'null') 
                  ? const Icon(Icons.person, size: 40, color: Colors.white) 
                  : null,
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 30,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => 
                        TakeServicePage(
                          userData: widget.userData,
                          workerName: widget.userData['username'] ?? 'Worker',
                          bookingId: bookingId,
                        )
                      )
                    ).then((value) {
                      _fetchPendingJobs(); 
                    });
                  },
                  icon: const Icon(Icons.check_box_outlined, size: 14, color: Colors.white),
                  label: const Text(
                    "Take Services",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6495ED),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 20),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                
                _buildInfoRow(Icons.access_time, "Time      : $time"),
                _buildInfoRow(Icons.location_on, "Address : $address"),
                _buildInfoRow(Icons.phone,       "No. Phone : $phone"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.2, 
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}