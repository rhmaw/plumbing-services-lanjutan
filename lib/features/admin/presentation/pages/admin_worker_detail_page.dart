import 'package:flutter/material.dart';

import '../../../../core/api/auth_service.dart';

class WorkerDetailPage extends StatefulWidget {
  final Map<String, dynamic> workerData;

  const WorkerDetailPage({super.key, required this.workerData});

  @override
  State<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.workerData['status'] ?? 'Pending';
  }

  void _updateStatus(String status) async {
    setState(() => _isLoading = true);

    int appId = int.tryParse(widget.workerData['id'].toString()) ?? 0;
    
    bool success = await _authService.updateWorkerStatus(appId, status);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      setState(() {
        _currentStatus = status;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Status berhasil diubah menjadi: $status"),
        backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengupdate status"), backgroundColor: Colors.red)
      );
    }
  }

  void _showConfirmationDialog(String actionType) {
    bool isApprove = actionType == 'Approved';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Center(
            child: Text(
              isApprove ? "Terima Pekerja" : "Tolak Pekerja",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: Text(
            isApprove 
                ? "Apakah Anda yakin ingin menerima pekerja ini?" 
                : "Apakah Anda yakin ingin menolak pekerja ini?",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateStatus(actionType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? const Color(0xFF00C800) : Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: Text(
                isApprove ? "Terima" : "Tolak",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB3B3),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                elevation: 0,
              ),
              child: const Text("Batal", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFCDE4FF),
      appBar: AppBar(
        title: const Text("Detail Pekerja", style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color.fromARGB(0, 51, 57, 228),
        foregroundColor: const Color(0xFF0066FF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white, 
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0066FF)),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        leadingWidth: 70,
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // TAMPILAN MOBILE
  Widget _buildMobileLayout() {
    String photoUrl = widget.workerData['photo_url'] ?? "https://via.placeholder.com/150";
    String name = widget.workerData['name'] ?? "Nama Tidak Ada";

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 60, 
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(photoUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 60),
            )
          ),
          const SizedBox(height: 15),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
              ]
            ),
            child: Column(
              children: [
                _buildDetailRow("Nama", name),
                _buildDetailRow("Telepon", widget.workerData['phone_number'] ?? "-"),
                _buildDetailRow("Email", widget.workerData['email'] ?? "-"),
                _buildDetailRow("Alamat", widget.workerData['address'] ?? "-"),
                _buildDetailRow("Jenis Kelamin", widget.workerData['gender'] ?? "-"),
                _buildDetailRow("Keahlian", widget.workerData['skills'] ?? "-", isMultiLine: true),
                _buildDetailRow("Portfolio", widget.workerData['portfolio'] ?? "-"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: _buildActionButtons(isMobile: true),
          ),
        ],
      ),
    );
  }

  // TAMPILAN DESKTOP
  Widget _buildDesktopLayout() {
    String photoUrl = widget.workerData['photo_url'] ?? "https://via.placeholder.com/150";
    String name = widget.workerData['name'] ?? "Nama Tidak Ada";

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 950, maxHeight: 550), // Ukuran Card Proporsional
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10))
          ]
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                        ]
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(photoUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 80),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    Text(
                      name, 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), 
                      textAlign: TextAlign.center
                    ),
                    
                    const Spacer(),
                    
                    _buildActionButtons(isMobile: false), 
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDetailRow("Nama", name),
                      _buildDetailRow("Telepon", widget.workerData['phone_number'] ?? "08123456789"),
                      _buildDetailRow("Email", widget.workerData['email'] ?? "-"),
                      _buildDetailRow("Alamat", widget.workerData['address'] ?? "N/A"),
                      _buildDetailRow("Jenis Kelamin", widget.workerData['gender'] ?? "Female"),
                      _buildDetailRow("Keahlian", widget.workerData['skills'] ?? "-", isMultiLine: true),
                      _buildDetailRow("Portfolio", widget.workerData['portfolio'] ?? "s.id/portfolio_r"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons({required bool isMobile}) {
    if (_currentStatus != 'Pending') {
      return Container(
        width: isMobile ? double.infinity : 200,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: _currentStatus == 'Approved' ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _currentStatus == 'Approved' ? Colors.green : Colors.red,
            width: 1.5
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _currentStatus == 'Approved' ? Icons.check_circle : Icons.cancel,
              color: _currentStatus == 'Approved' ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _currentStatus == 'Approved' ? "DITERIMA" : "DITOLAK",
              style: TextStyle(
                color: _currentStatus == 'Approved' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 40,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _showConfirmationDialog('Approved'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C800),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: const Text("Terima", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 100,
          height: 40,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _showConfirmationDialog('Rejected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB3B3),
              foregroundColor: Colors.red,
              elevation: 0, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.zero,
            ),
            child: const Text("Tolak", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87))
          ),
          const Text(":", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.3), 
              maxLines: isMultiLine ? 10 : 2, 
              overflow: TextOverflow.ellipsis
            )
          ),
        ],
      ),
    );
  }
}