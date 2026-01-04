import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../history/presentation/pages/history_page.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String? selectedWorkerName;
  final String? workerRating;
  final String? workerJobs;

  const BookingPage({
    super.key, 
    required this.userData, 
    this.selectedWorkerName,
    this.workerRating,
    this.workerJobs
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedService = "Instalasi Pipa";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workerNameController = TextEditingController();
  bool _isLoading = false;

  final List<String> _serviceTypes = [
    "Perbaikan Kebocoran", "Instalasi Pipa", "Pembersihan Saluran", "Perawatan Rutin"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedWorkerName != null) {
      _workerNameController.text = widget.selectedWorkerName!;
    }
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.247.163.60:8080/api'; 
    return 'http://127.0.0.1:8080/api';
  }

  void _handleOrder() async {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon lengkapi Tanggal & Waktu!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/booking/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": widget.userData['id'],
          "service_type": _selectedService,
          "booking_date": _dateController.text,
          "booking_time": _timeController.text,
          "worker_name": _workerNameController.text.isNotEmpty ? _workerNameController.text : null 
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Berhasil!"), backgroundColor: Colors.green));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryPage(userData: widget.userData)));
      } else {
        throw Exception("Gagal order: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Booking Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF6395F8),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            if (widget.selectedWorkerName != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.shade300),
                  boxShadow: [
                    BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))
                  ]
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.verified, color: Colors.green, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Teknisi Pilihan AI", style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(widget.selectedWorkerName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 5),
                          
                          if (widget.workerRating != null) 
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(" ${widget.workerRating}/5.0  •  ", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                const Icon(Icons.work, color: Colors.blueGrey, size: 16),
                                Text(" ${widget.workerJobs} Jobs", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],

            _buildLabel("Pilih Jenis Layanan"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedService,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _serviceTypes.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                  onChanged: (val) => setState(() => _selectedService = val),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Tanggal Layanan"),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: _inputDecoration(hint: "YYYY-MM-DD", icon: Icons.calendar_today_outlined),
              onTap: () async {
                 DateTime? d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                 if(d != null) setState(() => _dateController.text = d.toString().split(' ')[0]);
              },
            ),
            const SizedBox(height: 20),

            _buildLabel("Waktu Layanan"),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: _inputDecoration(hint: "Waktu Layanan", icon: Icons.history),
              onTap: () async {
                 TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                 if(t != null) setState(() => _timeController.text = t.format(context));
              },
            ),
            
            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rincian Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildPriceRow("Mudah", "Rp. 50.000"),
                  _buildPriceRow("Sedang", "Rp. 70.000"),
                  _buildPriceRow("Sulit", "Rp. 100.000"),
                  const SizedBox(height: 15),
                  const Text(
                    "*Harga final dapat berubah berdasarkan kondisi lapangan.", 
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity, 
              height: 50, 
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6395F8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Order Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ),
            
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity, 
              height: 50, 
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF6B6B)), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: const Text("Cancel", style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: Icon(icon, color: const Color(0xFF6395F8)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}