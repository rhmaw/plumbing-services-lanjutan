import 'package:flutter/material.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/pages/admin_profile_page.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/pages/admin_registration_page.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/pages/admin_worker_history_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _index = 0;

  final List<Widget> pages = [
    AdminRegistrationPage(),
    AdminWorkerHistoryPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
