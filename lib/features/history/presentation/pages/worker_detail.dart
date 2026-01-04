import 'package:flutter/material.dart';

class PemasukanDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String workerId;

  const PemasukanDetailPage({
    super.key, 
    required this.data, 
    required this.workerId
  });

  String formatRupiah(dynamic amount) {
    if (amount == null) return "Rp. 0";
    double val = double.tryParse(amount.toString()) ?? 0;
    String str = val.toStringAsFixed(0);
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result = str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return "Rp. $result";
  }

  @override
  Widget build(BuildContext context) {
    double totalGaji = double.tryParse(data['total_price']?.toString() ?? '0') ?? 0;
    
    double adminFee = totalGaji * 0.10; 
    
    double totalDiterima = totalGaji - adminFee;

    String name = data['customer_name'] ?? 'User';
    String email = data['customer_email'] ?? data['email'] ?? 'user@gmail.com';
    String phone = data['customer_phone'] ?? '08123456789';
    String address = data['customer_address'] ?? 'Indonesia';
    String photoUrl = data['customer_photo'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6495ED),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pemasukan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EEFD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: (photoUrl.isNotEmpty && photoUrl != 'null')
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/images/user_placeholder.png') as ImageProvider,
                        child: (photoUrl.isEmpty || photoUrl == 'null') 
                            ? const Icon(Icons.person, size: 35, color: Colors.white) 
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  _buildDetailRow("Username", name),
                  _buildDetailRow("Email", email),
                  _buildDetailRow("ID Worker", workerId),
                  _buildDetailRow("No. Telepon", phone),
                  _buildDetailRow("Alamat", address),
                  _buildDetailRow("Periode", "N/A"),
                  _buildDetailRow("Total Gaji", formatRupiah(totalGaji)),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 130,
                          child: Text(
                            "Potongan Admin\n(10%) :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(" :   ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            formatRupiah(adminFee),
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 130,
                        child: Text(
                          "Total Diterima",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                       const Text(" :   ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        formatRupiah(totalDiterima),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mengekspor data...")),
                    );
                  },
                  icon: const Icon(Icons.print, color: Colors.white),
                  label: const Text(
                    "Export",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6495ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, 
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          const Text(" :   ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}