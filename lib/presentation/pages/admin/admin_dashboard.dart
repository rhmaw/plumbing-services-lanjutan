import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // SECTION: ADMIN GREETING
            // ============================
            const Text(
              "Welcome, Admin 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // ============================
            // SECTION: SUMMARY CARDS
            // ============================
            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    title: "Total Worker",
                    count: "12",
                    icon: Icons.engineering,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: summaryCard(
                    title: "Total User",
                    count: "54",
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    title: "Pending Verification",
                    count: "3",
                    icon: Icons.verified_user,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: summaryCard(
                    title: "Orders Today",
                    count: "8",
                    icon: Icons.receipt_long,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Menu Admin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ============================
            // SECTION: GRID MENU
            // ============================
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                dashboardMenu(
                  icon: Icons.verified_user,
                  title: "Verify Worker",
                  color: Colors.orange,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.engineering,
                  title: "Kelola Worker",
                  color: Colors.blue,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.people,
                  title: "Kelola User",
                  color: Colors.green,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.history,
                  title: "Order History",
                  color: Colors.red,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.attach_money,
                  title: "Gaji Worker",
                  color: Colors.teal,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.reviews,
                  title: "Review",
                  color: Colors.purple,
                  onTap: () {},
                ),
                dashboardMenu(
                  icon: Icons.person,
                  title: "Profile",
                  color: Colors.grey,
                  onTap: () {
                    Navigator.pushNamed(context, "/adminProfile");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // WIDGET: SUMMARY CARD
  // ============================
  Widget summaryCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // WIDGET: GRID MENU ITEM
  // ============================
  Widget dashboardMenu({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
