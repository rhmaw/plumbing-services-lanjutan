import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/auth_service.dart';
import '../bloc/worker_bloc/worker_bloc.dart';
import '../bloc/worker_bloc/worker_event.dart';
import '../bloc/worker_bloc/worker_state.dart';
import 'admin_history_page.dart';
import 'admin_profile_page.dart';
import 'admin_worker_detail_page.dart';

class AdminHomePage extends StatefulWidget {
  final Map<String, dynamic>? adminData;

  const AdminHomePage({super.key, this.adminData});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BlocProvider(
        create: (context) => WorkerBloc(AuthService())..add(LoadWorkers()),
        child: AdminDashboardTab(adminData: widget.adminData),
      ),
      const AdminHistoryPage(),
      AdminProfilePage(
        adminData: widget.adminData ?? {},
        onBackToHome: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        if (isDesktop && _selectedIndex == 2) {
          return Scaffold(body: _pages[2]);
        }

        if (isDesktop) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                Container(
                  width: 250,
                  color: const Color(0xFF6395F8),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildSidebarItem(0, Icons.home, "Home"),
                      _buildSidebarItem(1, Icons.history, "History"),
                      _buildSidebarItem(2, Icons.person, "Profile"),
                    ],
                  ),
                ),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: _pages[_selectedIndex],
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFF6395F8),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  backgroundColor: const Color(0xFF6395F8),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white60,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
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
      },
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
      onTap: () => _onItemTapped(index),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    );
  }
}

// --- ADMIN TAB ---
class AdminDashboardTab extends StatelessWidget {
  final Map<String, dynamic>? adminData;

  const AdminDashboardTab({super.key, this.adminData});

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  }

  Widget _buildNotificationBell(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToNotifications(context),
      child: Stack(
        children: [
          const Icon(Icons.notifications, color: Color(0xFF8AB4F8), size: 30),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('notifications')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                bool hasUnread = snapshot.data!.docs.any((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['isRead'] != true;
                });
                if (hasUnread) {
                  return Positioned(
                    right: 3,
                    top: 3,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        Widget content = Column(
          children: [
            if (!isDesktop)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Registration Data",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateToNotifications(context),
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Color(0xFF0066FF),
                            size: 28,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('notifications')
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                bool hasUnread = snapshot.data!.docs.any(
                                  (doc) => doc['isRead'] != true,
                                );
                                if (hasUnread) {
                                  return Positioned(
                                    right: 3,
                                    top: 3,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // --- SEARCH BAR ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFB3D1FF)),
                ),
                child: TextField(
                  onChanged: (value) {
                    context.read<WorkerBloc>().add(SearchWorkers(value));
                  },
                  decoration: const InputDecoration(
                    hintText: "Search by name",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- LIST DATA PEKERJA ---
            Expanded(
              child: BlocBuilder<WorkerBloc, WorkerState>(
                builder: (context, state) {
                  if (state is WorkerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WorkerLoaded) {
                    if (state.filteredWorkers.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada data pelamar."),
                      );
                    }

                    if (isDesktop) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.8,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                        itemCount: state.filteredWorkers.length,
                        itemBuilder: (context, index) {
                          return _buildWorkerCard(
                            context,
                            state.filteredWorkers[index],
                          );
                        },
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.filteredWorkers.length,
                        itemBuilder: (context, index) {
                          return _buildWorkerCard(
                            context,
                            state.filteredWorkers[index],
                          );
                        },
                      );
                    }
                  } else if (state is WorkerError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        );

        if (isDesktop) {
          String adminName = adminData?['username'] ?? 'Admin';
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Halo selamat datang $adminName",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.face,
                            color: Color(0xFF0066FF),
                            size: 28,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: _buildNotificationBell(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(child: content),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(child: content);
        }
      },
    );
  }

  Widget _buildWorkerCard(BuildContext context, Map<String, dynamic> data) {
    String photoUrl = data['photo_url'] ?? "https://i.pravatar.cc/150";
    String name = data['name'] ?? "No Name";
    String skills = data['skills'] ?? "-";
    String email = data['email'] ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD6E4FF)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
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
                backgroundImage: NetworkImage(photoUrl),
                onBackgroundImageError: (_, __) {},
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 25,
                width: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => WorkerDetailPage(workerData: data),
                      ),
                    ).then((_) {
                      context.read<WorkerBloc>().add(LoadWorkers());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3D1FF),
                    foregroundColor: const Color(0xFF0066FF),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "More Info",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        skills,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- NOTIFICATION ---
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF6395F8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0066FF),
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('created_at', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Terjadi kesalahan"));
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("Belum ada notifikasi baru"));

          final docs = snapshot.data!.docs;

          if (isDesktop) {
            return GridView.builder(
              padding: const EdgeInsets.all(40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.8,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, docs[index]);
              },
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, docs[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    QueryDocumentSnapshot doc,
  ) {
    var data = doc.data() as Map<String, dynamic>;

    Map<String, dynamic> workerData = {
      'id': data['worker_id'] ?? '0',
      'name': data['name'] ?? 'Unknown',
      'email': data['email'] ?? '-',
      'skills': data['description'] ?? '-',
      'photo_url': data['photo_url'] ?? 'https://i.pravatar.cc/150',
    };

    String name = data['name'] ?? 'Unknown';
    String email = data['email'] ?? '-';
    String description = data['description'] ?? '-';
    String photoUrl = data['photo_url'] ?? 'https://i.pravatar.cc/150';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEFD),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 25,
                width: 80,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(doc.id)
                        .update({'isRead': true});
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  WorkerDetailPage(workerData: workerData),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3D1FF),
                    foregroundColor: const Color(0xFF0066FF),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "More Info",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
