import 'package:flutter/material.dart';
import 'package:plumbing_services_pml_kel4/presentation/pages/user/user_booking_page.dart';
import 'package:plumbing_services_pml_kel4/presentation/pages/user/user_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String? username;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==== HEADER ====
              Text(
                "Hi, $username 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Apa yang ingin kamu lakukan hari ini?",
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 20),

              // ==== MENU QUICK ACTION ====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _menuButton(
                    icon: Icons.build,
                    label: "Pesan Jasa",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UserBookingPage(),
                        ),
                      );
                    },
                  ),

                  _menuButton(
                    icon: Icons.history,
                    label: "Riwayat",
                    onTap: () {
                      // TODO: Buat halaman riwayat
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ==== SECTION WORKER LIST / SERVICES ====
              const Text(
                "Rekomendasi Pekerja",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Dummy card worker (nanti sambungkan ke API)
              _workerCard(
                name: "Budi",
                job: "Tukang Ledeng",
              ),

              _workerCard(
                name: "Agus",
                job: "Tukang AC",
              ),

              _workerCard(
                name: "Dedi",
                job: "Elektrik",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== WIDGET MENU ====
  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.blue),
            const SizedBox(height: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  // ==== KARTU WORKER ====
  Widget _workerCard({required String name, required String job}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: const Icon(Icons.person, size: 40),
        title: Text(name),
        subtitle: Text(job),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Klik worker → ke halaman booking worker tertentu
        },
      ),
    );
  }
}
