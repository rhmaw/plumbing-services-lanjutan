import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import 'worker_list_page.dart';
import 'recommendation_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = "Pilih Layanan"; 
  final List<String> _categories = [
    "Pilih Layanan",
    "Perbaikan Kebocoran",
    "Instalasi Pipa",
    "Pembersihan Saluran",
    "Perawatan Saluran"
  ];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryPage(userData: widget.userData)));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage(userData: widget.userData)));
    }
  }

  void _navigateToWorkerList(String category) async {
    if (category == "Pilih Layanan") return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkerListPage(
          userData: widget.userData, 
          initialCategory: category
        ),
      ),
    );
  }

  void _navigateToAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(userData: widget.userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: isDesktop 
          ? null 
          : Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: AppColors.primaryBlue,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: BottomNavigationBar(
                  backgroundColor: AppColors.primaryBlue,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white60,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onNavTapped,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              ),
            ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // LAYOUT MOBILE
  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildMainContent(isDesktop: false),
          ],
        ),
      ),
    );
  }

  // DESKTOP
  Widget _buildDesktopLayout() {
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
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildDropdown(),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _buildMainContent(isDesktop: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    String displayUsername = widget.userData['username'] ?? 'User';
    return Row(
      children: [
        const Icon(Icons.face_rounded, color: Color(0xFF0066FF), size: 40), 
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Halo selamat datang", 
              style: TextStyle(fontSize: 14, color: Color(0xFF6395F8))
            ),
            Text(
              displayUsername, 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0066FF))
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF0066FF), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _categories.contains(_selectedCategory) ? _selectedCategory : _categories[0],
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0066FF), size: 30),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
            if (newValue != "Pilih Layanan") {
              _navigateToWorkerList(newValue!);
            }
          },
          items: _categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white60),
      title: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onTap: () => _onNavTapped(index),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    );
  }

  Widget _buildMainContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        GestureDetector(
          onTap: _navigateToAI,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF6395F8), Color(0xFF4A7ED6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.yellow, size: 32),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rekomendasi AI",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Cari teknisi terbaik dengan bantuan AI kami.",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        const Text("Order by category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        
        const SizedBox(height: 15),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isDesktop ? 4 : 2, 
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.5,
          children: [
            _buildCategoryItem("https://images.unsplash.com/photo-1581092921461-eab62e97a783?q=80&w=200", "Perbaikan Kebocoran"),
            _buildCategoryItem("https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?q=80&w=200", "Instalasi Pipa"),
            _buildCategoryItem("https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=200", "Pembersihan Saluran"),
            _buildCategoryItem("https://images.unsplash.com/photo-1581244277943-fe4a9c777189?q=80&w=200", "Perawatan Saluran"),
          ],
        ),

        const SizedBox(height: 30),

        Container(
          width: double.infinity,
          height: isDesktop ? 250 : 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF6395F8), Color(0xFF4A7ED6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0, bottom: 0, top: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                  child: Opacity(
                    opacity: 0.85,
                    child: Image.network(
                      "https://images.unsplash.com/photo-1581141849291-1125c7b692b5?q=80&w=400", 
                      fit: BoxFit.cover,
                      width: isDesktop ? 400 : 200, 
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "PLUMBING\nSERVICES", 
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Pipa tersumbat? panggil kami", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Layanan cepat & profesional.", 
                      style: TextStyle(color: Colors.white70, fontSize: 11)
                    ),
                    const Spacer(),
                    Row(children: [
                      _buildDot(true), 
                      _buildDot(false), 
                      _buildDot(false)
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imageUrl, String categoryName) {
    return GestureDetector(
      onTap: () => _navigateToWorkerList(categoryName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Text(
            categoryName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 8, width: 8,
      decoration: BoxDecoration(color: isActive ? Colors.white : Colors.white38, shape: BoxShape.circle),
    );
  }
}