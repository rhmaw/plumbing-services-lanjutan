import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../worker/presentation/pages/worker_history_page.dart'; 

class TakeServicePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String workerName;
  final int bookingId;

  const TakeServicePage({
    super.key, 
    required this.userData, 
    required this.workerName,
    required this.bookingId,
  });

  @override
  State<TakeServicePage> createState() => _TakeServicePageState();
}

class _TakeServicePageState extends State<TakeServicePage> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workerController = TextEditingController();
  final TextEditingController _pipeController = TextEditingController();
  
  String _difficulty = 'Mudah';
  String _status = 'Finished'; 
  double _totalBiaya = 50000;
  bool _isLoading = false;

  final List<String> _difficultyOptions = ['Mudah', 'Sedang', 'Sulit'];
  final List<String> _statusOptions = ['Finished', 'Accepted', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _workerController.text = widget.workerName;
    _timeController.text = DateTime.now().toString().substring(0, 16);
  }

  void _calculatePrice() {
    setState(() {
      double basePrice = 50000;
      if (_difficulty == 'Sedang') basePrice = 75000;
      if (_difficulty == 'Sulit') basePrice = 100000;
      
      int pipes = int.tryParse(_pipeController.text) ?? 0;
      _totalBiaya = basePrice + (pipes * 10000);
    });
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.126.120.69:8080/api';
    return 'http://10.126.120.69:8080/api'; 
  }

  Future<void> _sendData() async {
    setState(() => _isLoading = true);
    final String baseUrl = getBaseUrl();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/booking/createWorker'),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          "booking_id": widget.bookingId,
          "user_id": widget.userData['id'],
          "worker_name": _workerController.text,
          "service_time": _timeController.text,
          "pipe_count": int.tryParse(_pipeController.text) ?? 0,
          "difficulty": _difficulty,
          "status": _status, 
          "total_price": _totalBiaya
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pekerjaan Selesai & Tersimpan!"), backgroundColor: Colors.green));
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WorkerHistoryPage(
            userData: widget.userData 
          )),
        );
      } else {
        throw Exception("Server Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take Services"), backgroundColor: const Color(0xFF6395F8)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Service Time"),
            TextField(controller: _timeController, readOnly: true, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 15),
            
            _buildLabel("Worker"),
            TextField(controller: _workerController, readOnly: true, decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.black12)),
            const SizedBox(height: 15),

            _buildLabel("Jumlah Pipa Diperbaiki"),
            TextField(controller: _pipeController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Jumlah", border: OutlineInputBorder()), onChanged: (v) => _calculatePrice()),
            const SizedBox(height: 15),

            _buildLabel("Tingkat Kesulitan"),
            DropdownButtonFormField(
              value: _difficulty, 
              items: _difficultyOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), 
              onChanged: (v) { 
                setState(() { 
                  _difficulty = v!; 
                  _calculatePrice(); 
                }); 
              }, 
              decoration: const InputDecoration(border: OutlineInputBorder())
            ),
            const SizedBox(height: 15),

            _buildLabel("Status"),
            DropdownButtonFormField(
              value: _status, 
              items: _statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), 
              onChanged: (v) => setState(() => _status = v!), 
              decoration: const InputDecoration(border: OutlineInputBorder())
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              color: Colors.green[100],
              child: Text("Total Biaya: Rp ${_totalBiaya.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendData, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6395F8)), 
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Send", style: TextStyle(color: Colors.white))
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}