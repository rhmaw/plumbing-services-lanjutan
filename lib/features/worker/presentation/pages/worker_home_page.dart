import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'worker_history_page.dart';
import '../../../../features/profile/presentation/pages/worker_profile_page.dart';
import '../../../../features/home/presentation/pages/take_service_page.dart'; 

class WorkerHomePage extends StatefulWidget {
  final Map<String, dynamic> userData; 

  const WorkerHomePage({super.key, required this.userData});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      WorkerHomeContent(userData: widget.userData),
      WorkerHistoryPage(userData: widget.userData),
      WorkerProfilePage(userData: widget.userData),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.userData['username'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Halo selamat datang $userName ", style: const TextStyle(fontSize: 18)),
            const Icon(Icons.account_circle, color: Colors.white),
          ],
        ),
        backgroundColor: const Color(0xFF6395F8),
        elevation: 0,
        automaticallyImplyLeading: false, 
        centerTitle: true,
      ),
      
      body: _pages[_selectedIndex],
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF6395F8),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

class WorkerHomeContent extends StatefulWidget {
  final Map<String, dynamic> userData;

  const WorkerHomeContent({super.key, required this.userData});

  @override
  State<WorkerHomeContent> createState() => _WorkerHomeContentState();
}

class _WorkerHomeContentState extends State<WorkerHomeContent> {
  List<dynamic> _pendingJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingJobs();
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.126.120.69:8080/api';
    return 'http://10.126.120.69:8080/api';
  }

  Future<void> _fetchPendingJobs() async {
    String workerId = widget.userData['id']?.toString() ?? '1';
    String workerName = widget.userData['username'] ?? 'Worker';
    final url = Uri.parse('${getBaseUrl()}/booking/worker-pending/${Uri.encodeComponent(workerName)}');
    try {
      final response = await http.get(url);
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
      print("Error Fetch Jobs: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    if (_pendingJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.work_off_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("Belum ada pekerjaan masuk.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPendingJobs,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _pendingJobs.length,
        itemBuilder: (context, index) {
          final job = _pendingJobs[index];
          return _buildJobCard(context, job);
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    String name = job['customer_name'] ?? job['username'] ?? 'User';
    String time = job['booking_time'] ?? job['time'] ?? 'Now';
    String address = job['customer_address'] ?? job['address'] ?? 'No Address';
    String phone = job['customer_phone'] ?? job['phone'] ?? '-';
    int bookingId = int.tryParse(job['id'].toString()) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF6395F8), size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    _iconText(Icons.access_time, "Time : $time"),
                    _iconText(Icons.location_on, "Address : $address"),
                    _iconText(Icons.phone, "No. Phone : $phone"),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (bookingId == 0) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Error: ID Booking tidak valid"))
                   );
                   return;
                }

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakeServicePage(
                    userData: widget.userData,
                    workerName: widget.userData['username'] ?? 'Worker',
                    bookingId: bookingId,
                  )),
                );
                if (result == true || result == null) {
                  _fetchPendingJobs();
                }
              },
              icon: const Icon(Icons.check_box_outlined, size: 20),
              label: const Text("Take Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6395F8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800]), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}