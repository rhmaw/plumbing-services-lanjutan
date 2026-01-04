import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/login_page.dart'; 
import '../../../home/presentation/pages/worker_service_page.dart'; 
import '../../../history/presentation/pages/worker_history_page.dart';
import 'edit_profile_worker_page.dart';

class WorkerProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const WorkerProfilePage({super.key, required this.userData});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.userData;
  }

  // --- LOGIKA LOGOUT ---
  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _navigateToEditProfile() async {
    final updatedResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileWorkerPage(currentData: _currentData),
      ),
    );

    if (updatedResult != null) {
      setState(() {
        _currentData = updatedResult;
      });
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => WorkerServicePage(userData: _currentData))
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => WorkerHistoryPage(userData: _currentData))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = _currentData['username'] ?? 'User';
    String address = _currentData['address'] ?? 'Default Address';
    String email = _currentData['email'] ?? 'email@example.com';
    String phone = _currentData['phone'] ?? _currentData['phone_number'] ?? '08123456789';
    String photoUrl = _currentData['photo_url'] ?? ""; 

    return Scaffold(
      backgroundColor: const Color(0xFF6495ED),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: -60,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Profile Teknisi",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 20, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: (photoUrl.isNotEmpty && photoUrl != 'null')
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/images/user_placeholder.png') as ImageProvider,
                        child: (photoUrl.isEmpty || photoUrl == 'null')
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    children: [
                      _buildInfoRow(Icons.location_on, "Address", address),
                      _buildInfoRow(Icons.email, "E-mail", email),
                      _buildInfoRow(Icons.phone, "Phone", phone),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _navigateToEditProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF75A8FF),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: _handleLogout,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFFF6B6B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Color(0xFF6495ED),
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
              currentIndex: 2,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) => _onBottomNavTapped(index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6495ED), size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}