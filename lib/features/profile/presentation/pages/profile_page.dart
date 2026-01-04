import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import 'edit_profile_page.dart';
import 'worker_registration_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 2;
  late Map<String, dynamic> currentUserData;

  @override
  void initState() {
    super.initState();
    currentUserData = widget.userData;
  }

  void _navigateToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(userData: currentUserData)),
    );

    if (updatedData != null && updatedData is Map<String, dynamic>) {
      setState(() {
        currentUserData = updatedData;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Konfirmasi Logout", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = currentUserData['username'] ?? '';
    String email = currentUserData['email'] ?? '';
    String phone = currentUserData['phone_number'] ?? '';
    String address = currentUserData['address'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          Container(
            height: 400, width: double.infinity,
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6395F8), Color(0xFF82B0FF)])),
          ),
          Positioned(top: -100, left: -50, child: Container(width: 250, height: 250, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: const BorderRadius.only(bottomRight: Radius.circular(150), bottomLeft: Radius.circular(50))))),
          Positioned(top: 100, right: -80, child: Container(width: 200, height: 250, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: const BorderRadius.only(topLeft: Radius.circular(120), bottomLeft: Radius.circular(80))))),

          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("User Profile", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                CircleAvatar(
                  radius: 50, backgroundColor: Colors.white,
                  child: const CircleAvatar(radius: 46, backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=5")),
                ),
                const SizedBox(height: 10),
                Text(username, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.location_on, "Address", address),
                          const Divider(height: 30, color: Color(0xFFEEEEEE)),
                          _buildInfoRow(Icons.email, "E-mail", email),
                          const Divider(height: 30, color: Color(0xFFEEEEEE)),
                          _buildInfoRow(Icons.phone, "Phone", phone),
                          
                          const SizedBox(height: 40),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _navigateToEditProfile,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6395F8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                              child: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => _showLogoutDialog(context),
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF6B6B)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: const Text("Logout", style: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => WorkerRegistrationPage(userData: currentUserData)
                                  )
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6395F8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                              child: const Text("Pendaftaran menjadi worker", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: AppColors.primaryBlue),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primaryBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            currentIndex: _selectedIndex,
            onTap: (index) {
                if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userData: currentUserData)));
                else if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryPage(userData: currentUserData)));
            },
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: const Color(0xFF6395F8), size: 28),
      const SizedBox(width: 20),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
      ]))
    ]);
  }
}