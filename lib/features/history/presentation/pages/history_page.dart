import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HistoryPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HistoryPage({super.key, required this.userData});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _allHistory = [];
  bool _isLoading = true;
  int _selectedIndex = 1;

  final Color _mainBlue = const Color(0xFF6495ED);
  final Color _headerTextBlue = const Color(0xFF0066FF);
  final Color _tabBarBg = const Color(0xFF6495ED);
  final Color _tabIndicatorBg = const Color(0xFFD6E4FF);
  final Color _cardBg = const Color(0xFFE3F2FD);

  final Color _badgeAccepted = const Color(0xFF448AFF);
  final Color _badgeFinish = const Color(0xFF00C853);
  final Color _badgeRejected = const Color(0xFFD32F2F);
  final Color _badgePending = const Color(0xFFFFA726);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchHistory();
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http:// 10.239.218.41:8080/api';
    return 'http://127.0.0.1:8080/api';
  }

  Future<void> _fetchHistory() async {
    final url = Uri.parse(
      '${getBaseUrl()}/booking/list/${widget.userData['id']}',
    );
    try {
      final response = await http.get(
        url,
        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _allHistory = json['data'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error History: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsFinish(String bookingId) async {
    final url = Uri.parse('${getBaseUrl()}/booking/update-status');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"booking_id": bookingId, "status": "Finished"}),
      );
      if (response.statusCode == 200) {
        _fetchHistory();
        _tabController.animateTo(2);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pesanan Selesai! Silahkan beri nilai."),
            ),
          );
      }
    } catch (e) {
      print("Error Finish: $e");
    }
  }

  Future<void> _submitReview(
    String bookingId,
    String workerName,
    int rating,
    String comment,
  ) async {
    final url = Uri.parse('${getBaseUrl()}/booking/submit-review');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "booking_id": bookingId,
          "user_id": widget.userData['id'],
          "worker_name": workerName,
          "rating": rating,
          "comment": comment,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context);
        await _fetchHistory();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ulasan berhasil dikirim!")),
          );
        }
      }
    } catch (e) {
      print("Error Review: $e");
    }
  }

  void _showReviewDialog(Map<String, dynamic> item) {
    int rating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.grey[400]),
                      ),
                    ),
                    const Text(
                      "Suka dengan layanan\nkami? Berikan penilaian",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () => setDialogState(() => rating = index + 1),
                          child: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Tulis ulasan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFCDD2),
                              foregroundColor: Colors.red,
                              elevation: 0,
                            ),
                            child: const Text("Batal"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (rating > 0)
                                _submitReview(
                                  item['id'].toString(),
                                  item['worker_name'] ?? 'Worker',
                                  rating,
                                  commentController.text,
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8E6C9),
                              foregroundColor: Colors.green,
                              elevation: 0,
                            ),
                            child: const Text("Kirim"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userData: widget.userData),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(userData: widget.userData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          isDesktop
              ? null
              : Container(
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
                    unselectedItemColor: const Color.fromARGB(
                      255,
                      180,
                      215,
                      255,
                    ),
                    currentIndex: _selectedIndex,
                    type: BottomNavigationBarType.fixed,
                    showUnselectedLabels: true,
                    onTap: _onNavTapped,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: "History",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order History",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _headerTextBlue,
                  fontSize: 24,
                ),
              ),
            ),
          ),

          _buildTabBar(isDesktop: false),

          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHistoryList(
                          _getFilteredList('Pending'),
                          "Belum ada pesanan pending",
                          isDesktop: false,
                        ),
                        _buildHistoryList(
                          _getFilteredList('Accepted'),
                          "Belum ada pesanan diproses",
                          isDesktop: false,
                        ),
                        _buildHistoryList(
                          _getFilteredList('Finish'),
                          "Belum ada riwayat selesai",
                          isDesktop: false,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 250,
          color: _mainBlue,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _headerTextBlue,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 700,
                    child: _buildTabBar(isDesktop: true),
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildHistoryList(
                                _getFilteredList('Pending'),
                                "Belum ada pesanan pending",
                                isDesktop: true,
                              ),
                              _buildHistoryList(
                                _getFilteredList('Accepted'),
                                "Belum ada pesanan diproses",
                                isDesktop: true,
                              ),
                              _buildHistoryList(
                                _getFilteredList('Finish'),
                                "Belum ada riwayat selesai",
                                isDesktop: true,
                              ),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar({required bool isDesktop}) {
    return Container(
      height: 50,
      margin:
          isDesktop
              ? const EdgeInsets.symmetric(vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _tabBarBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: _tabIndicatorBg,
          borderRadius: BorderRadius.circular(30),
        ),
        labelColor: Colors.black87,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelColor: Colors.white,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Accepted"),
          Tab(text: "Finish"),
        ],
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

  Widget _buildHistoryList(
    List<dynamic> data,
    String emptyMsg, {
    required bool isDesktop,
  }) {
    if (data.isEmpty)
      return Center(
        child: Text(
          emptyMsg,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );

    if (isDesktop) {
      return GridView.builder(
        padding: const EdgeInsets.only(top: 10, right: 20, bottom: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
        ),
        itemCount: data.length,
        itemBuilder:
            (context, index) => _buildHistoryCard(data[index], isDesktop: true),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: data.length,
        itemBuilder:
            (context, index) =>
                _buildHistoryCard(data[index], isDesktop: false),
      );
    }
  }

  Widget _buildHistoryCard(
    Map<String, dynamic> item, {
    required bool isDesktop,
  }) {
    String status = item['status'] ?? 'Pending';
    Color badgeColor;
    String displayStatus = status;

    if (status == 'Accepted' || status == 'On Process') {
      badgeColor = _badgeAccepted;
      displayStatus = "Accepted";
    } else if (status == 'Finish' ||
        status == 'Finished' ||
        status == 'Completed') {
      badgeColor = _badgeFinish;
      displayStatus = "Finished";
    } else if (status == 'Rejected') {
      badgeColor = _badgeRejected;
    } else {
      badgeColor = _badgePending;
    }

    bool hasReview =
        (item['rating'] != null &&
            item['rating'].toString() != "0" &&
            item['rating'].toString() != "");
    int ratingVal =
        hasReview ? int.tryParse(item['rating'].toString()) ?? 0 : 0;
    String reviewComment = item['comment'] ?? item['review_comment'] ?? "";

    Widget detailColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isDesktop ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
      children: [
        _detailText("Tanggal", ": ${item['booking_date'] ?? '-'}"),
        SizedBox(height: isDesktop ? 0 : 5),
        _detailText("Waktu", ": ${item['booking_time'] ?? '-'}"),
        SizedBox(height: isDesktop ? 0 : 5),
        _detailText("Job ID", ": ${item['id'] ?? '-'}"),
        SizedBox(height: isDesktop ? 0 : 5),
        _detailText("Layanan", ": ${item['service_type'] ?? '-'}"),
        SizedBox(height: isDesktop ? 0 : 5),
        if (item['total_price'] != null)
          _detailText("Total Biaya", ": ${item['total_price']}"),
      ],
    );

    Widget actionSection = Column(
      children: [
        if (status == 'Accepted' || status == 'On Process')
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () => _markAsFinish((item['id'] ?? '').toString()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        if ((status == 'Finish' ||
                status == 'Finished' ||
                status == 'Completed') &&
            hasReview)
          Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < ratingVal ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFD700),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Ulasan : $reviewComment",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),

        if ((status == 'Finish' ||
                status == 'Finished' ||
                status == 'Completed') &&
            !hasReview)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GestureDetector(
              onTap: () => _showReviewDialog(item),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Beri Nilai: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(15),
        boxShadow:
            isDesktop
                ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Worker Name : ${item['worker_name'] ?? '-'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  displayStatus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          isDesktop ? Expanded(child: detailColumn) : detailColumn,

          actionSection,
        ],
      ),
    );
  }

  Widget _detailText(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<dynamic> _getFilteredList(String tabName) {
    return _allHistory.where((item) {
      String status = (item['status'] ?? '').toString();
      if (tabName == 'Pending') return status == 'Pending';
      if (tabName == 'Accepted')
        return status == 'Accepted' || status == 'On Process';
      if (tabName == 'Finish')
        return status == 'Finish' ||
            status == 'Finished' ||
            status == 'Completed' ||
            status == 'Rejected';
      return false;
    }).toList();
  }
}
