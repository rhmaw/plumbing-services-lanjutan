import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/history_bloc/history_bloc.dart';
import '../bloc/history_bloc/history_event.dart';
import '../bloc/history_bloc/history_state.dart';
import 'admin_salary_detail_page.dart';

class AdminHistoryPage extends StatelessWidget {
  const AdminHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()..add(LoadHistory()),
      child: const AdminHistoryView(),
    );
  }
}

class AdminHistoryView extends StatefulWidget {
  const AdminHistoryView({super.key});

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text("Riwayat Pekerja", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              backgroundColor: const Color(0xFF6395F8),
              foregroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                const Text(
                  "Riwayat Pekerja",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0066FF),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // --- SEARCH BAR ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFB3D1FF)),
                  boxShadow: isDesktop
                      ? [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                        ]
                      : [],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<HistoryBloc>().add(SearchHistory(value));
                  },
                  decoration: const InputDecoration(
                    hintText: "Search by name",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HistoryLoaded) {
                      if (state.filteredHistory.isEmpty) {
                        return const Center(child: Text("Tidak ada data riwayat"));
                      }

                      if (isDesktop) {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25,
                          ),
                          itemCount: state.filteredHistory.length,
                          itemBuilder: (context, index) {
                            return _buildDesktopCard(context, state.filteredHistory[index]);
                          },
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: state.filteredHistory.length,
                          itemBuilder: (context, index) {
                            return _buildMobileCard(context, state.filteredHistory[index]);
                          },
                        );
                      }
                    } else if (state is HistoryError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET CARD MOBILE ---
  Widget _buildMobileCard(BuildContext context, Map<String, dynamic> data) {
    String name = data['username'] ?? 'User Name';
    String email = data['email'] ?? 'email@example.com';
    String address = data['address'] ?? 'Sempor';
    String photoUrl = data['photo_url'] ?? "https://i.pravatar.cc/150?u=$name";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          
          Row(
            children: [
              const Icon(Icons.email, size: 14, color: Color(0xFF6395F8)),
              const SizedBox(width: 5),
              Expanded(child: Text(email, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 5),
          
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF6395F8)),
              const SizedBox(width: 5),
              Expanded(child: Text(address, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
            ],
          ),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSalaryDetailPage(workerData: data)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD6E4FF),
                foregroundColor: const Color(0xFF0066FF),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET CARD DESKTOP ---
  Widget _buildDesktopCard(BuildContext context, Map<String, dynamic> data) {
    String name = data['username'] ?? 'User Name';
    String email = data['email'] ?? 'email@example.com';
    String address = data['address'] ?? 'Alamat tidak tersedia';
    String photoUrl = data['photo_url'] ?? "https://i.pravatar.cc/150?u=$name";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(height: 15),
          
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Color(0xFF6395F8)),
              const SizedBox(width: 8),
              Expanded(child: Text(email, style: const TextStyle(fontSize: 13, color: Colors.black54), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF6395F8)),
              const SizedBox(width: 8),
              Expanded(child: Text(address, style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSalaryDetailPage(workerData: data)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD6E4FF),
                foregroundColor: const Color(0xFF0066FF),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Detail", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}