import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';

class AdminProfilePage extends StatelessWidget {
  final Map<String, dynamic> adminData;
  final VoidCallback? onBackToHome;

  const AdminProfilePage({
    super.key,
    required this.adminData,
    this.onBackToHome,
  });

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    if (isDesktop) {
      return _buildDesktopLayout(context, screenWidth);
    } else {
      return _buildMobileLayout(context, screenWidth);
    }
  }

  // TAMPILAN DESKTOP
  Widget _buildDesktopLayout(BuildContext context, double screenWidth) {
    String idAdmin = adminData['id'].toString();
    String email = adminData['email'] ?? 'admin@gmail.com';

    return Scaffold(
      backgroundColor: const Color(0xFF6395F8),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (onBackToHome != null) {
                      onBackToHome!();
                    } else if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Admin Plumbs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 90,
                    color: Color(0xFF6395F8),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  width: 650,
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 80),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Admin Plumbs",
                        style: TextStyle(
                          color: Color(0xFF6395F8),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoItem(Icons.card_membership, "ID Admin", idAdmin),
                          
                          const SizedBox(width: 80),
                          
                          _buildInfoItem(Icons.email, "E-mail", email),
                        ],
                      ),

                      const SizedBox(height: 60),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () => _handleLogout(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            foregroundColor: const Color(0xFFFF6B6B),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Info Item
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF6395F8), size: 32),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label, 
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: Colors.black87
              )
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.grey, 
                fontSize: 14,
                fontWeight: FontWeight.w500
              )
            ), 
          ],
        ),
      ],
    );
  }

  // TAMPILAN MOBILE
  Widget _buildMobileLayout(BuildContext context, double screenWidth) {
    String username = adminData['username'] ?? 'Super Admin';
    String idAdmin = adminData['id'].toString();
    String email = adminData['email'] ?? 'admin@gmail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                color: const Color(0xFF6395F8),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 120),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Admin Plumbs",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 90, color: Color(0xFF6395F8)),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.card_membership, color: Color(0xFF6395F8), size: 28),
                      const SizedBox(width: 15),
                      const Text("ID Admin :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                      const SizedBox(width: 20),
                      Text(idAdmin, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Color(0xFF6395F8), size: 28),
                      const SizedBox(width: 15),
                      const Text("E-mail    :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(email, style: const TextStyle(fontSize: 16, color: Colors.black87), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout, color: Color(0xFFFF6B6B)),
                      label: const Text("Logout", style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 16, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B6B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}