import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';

class WorkerJobDetailPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic> workerData;

  const WorkerJobDetailPage({super.key, required this.bookingData, required this.workerData});

  @override
  State<WorkerJobDetailPage> createState() => _WorkerJobDetailPageState();
}

class _WorkerJobDetailPageState extends State<WorkerJobDetailPage> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workerController = TextEditingController();
  final TextEditingController _pipeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  String _difficulty = 'Mudah';
  String _selectedStatus = 'Accepted'; 
  bool _isLoading = false;

  final List<String> _difficultyOptions = ['Mudah', 'Sedang', 'Sulit'];
  final List<String> _statusOptions = ['Accepted', 'Rejected', 'Finish'];

  @override
  void initState() {
    super.initState();
    _workerController.text = widget.workerData['username'];
    _timeController.text = widget.bookingData['booking_date'] + " " + widget.bookingData['booking_time'];
    _priceController.text = "50000";
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.126.120.69:8080/api';
    return 'http://10.126.120.69:8080/api';
  }

  Future<void> _handleSendUpdate() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('${getBaseUrl()}/booking/update-status');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          "booking_id": widget.bookingData['id'],
          "status": _selectedStatus,
          "pipe_count": _pipeController.text,
          "difficulty": _difficulty,
          "total_price": _priceController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status berhasil diubah menjadi $_selectedStatus"), backgroundColor: Colors.green)
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Gagal update status: ${response.body}');
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
            TextField(controller: _pipeController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Jumlah", border: OutlineInputBorder())),
            const SizedBox(height: 15),

            _buildLabel("Tingkat Kesulitan"),
            DropdownButtonFormField(value: _difficulty, items: _difficultyOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) { setState(() => _difficulty = v!); }, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 15),

            _buildLabel("Status"),
            DropdownButtonFormField(value: _selectedStatus, items: _statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _selectedStatus = v!), decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              color: Colors.green[100],
              child: Text("Total Biaya: Rp ${_priceController.text}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSendUpdate,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6395F8)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Send", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
}