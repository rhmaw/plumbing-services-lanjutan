import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import 'booking_page.dart';

class WorkerListPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String initialCategory;

  const WorkerListPage({
    super.key,
    required this.userData,
    required this.initialCategory,
  });

  @override
  State<WorkerListPage> createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  final List<String> _services = [
    "Perbaikan Kebocoran",
    "Instalasi Pipa",
    "Pembersihan Saluran",
    "Perawatan Saluran",
  ];

  late String _selectedService;
  int _selectedIndex = 0;
  List<dynamic> _workers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialCategory;
    if (!_services.contains(_selectedService)) {
      if (_services.isNotEmpty) _selectedService = _services[0];
    }
    _fetchWorkersFromDB();
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    return 'http://192.168.71.192:8080/api';
  }

  Future<void> _fetchWorkersFromDB() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/workers/list'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _workers = jsonDecode(response.body)['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(userData: widget.userData),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(userData: widget.userData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.userData['username'] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;

          Widget mainContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 30 : 20,
                  20,
                  isDesktop ? 30 : 20,
                  10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.face,
                          color: Color(0xFF6395F8),
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Halo selamat datang",
                              style: TextStyle(
                                color: Color(0xFF6395F8),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                color: Color(0xFF6395F8),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedService,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF6395F8),
                          ),
                          items: _services
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedService = val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _workers.isEmpty
                    ? const Center(child: Text("Tidak ada pekerja tersedia"))
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 30 : 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Kategori Pekerja Berkualitas",
                              style: TextStyle(
                                color: Color(0xFF6395F8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 15),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktop ? 4 : 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: isDesktop ? 20 : 15,
                                    mainAxisSpacing: isDesktop ? 20 : 15,
                                  ),
                              itemCount: _workers.length,
                              itemBuilder: (context, index) =>
                                  _buildWorkerCard(_workers[index]),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ],
          );

          if (isDesktop) {
            return Row(
              children: [
                Container(
                  width: 250,
                  color: const Color(0xFF6395F8),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      _buildSidebarItem(0, Icons.home, "Home"),
                      _buildSidebarItem(1, Icons.history, "History"),
                      _buildSidebarItem(2, Icons.person, "Profile"),
                    ],
                  ),
                ),
                Expanded(child: SafeArea(child: mainContent)),
              ],
            );
          } else {
            return SafeArea(child: mainContent);
          }
        },
      ),

      bottomNavigationBar: MediaQuery.of(context).size.width > 800
          ? null
          : Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Color(0xFF6395F8),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BottomNavigationBar(
                  backgroundColor: const Color(0xFF6395F8),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white60,
                  currentIndex: _selectedIndex,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onNavTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white60),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => _onNavTapped(index),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> worker) {
    String jobCount = "120 job";
    String imageUrl =
        worker['photo_url'] ??
        "https://i.pravatar.cc/150?u=${worker['username']}";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker['username'] ?? 'Worker',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        SizedBox(width: 2),
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$jobCount | Berkualitas",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Available",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          userData: widget.userData,
                          selectedWorkerName: worker['username'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD6E4FF),
                    foregroundColor: const Color(0xFF6395F8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  child: const Text(
                    "Booking",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
