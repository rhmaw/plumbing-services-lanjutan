import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class WorkerTakeServicePage extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const WorkerTakeServicePage({super.key, required this.jobData, required Map<String, dynamic> userData});

  @override
  State<WorkerTakeServicePage> createState() => _WorkerTakeServicePageState();
}

class _WorkerTakeServicePageState extends State<WorkerTakeServicePage> {
  final TextEditingController _jumlahPipaController = TextEditingController();
  String _selectedDifficulty = "Mudah";
  String _selectedStatus = "Accepted";
  bool _isSending = false;

  // URL Helper
  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://10.126.120.69:8080/api'; 
    return 'http://127.0.0.1:8080/api';
  }

  // Hitung Biaya (Contoh Sederhana)
  int _calculateCost() {
    int basePrice = 50000;
    int pipaPrice = 10000;
    int pipes = int.tryParse(_jumlahPipaController.text) ?? 0;
    
    if (_selectedDifficulty == "Sedang") basePrice += 20000;
    if (_selectedDifficulty == "Sulit") basePrice += 50000;

    return basePrice + (pipes * pipaPrice);
  }

  Future<void> _submitService() async {
    setState(() => _isSending = true);

    final url = Uri.parse('${getBaseUrl()}/booking/update-status');
    final cost = _calculateCost();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'booking_id': widget.jobData['id'],
          'worker_id': widget.jobData['worker_id'] ?? 1,
          'status': _selectedStatus,
          'difficulty': _selectedDifficulty,
          'pipes_repaired': _jumlahPipaController.text,
          'total_cost': cost,
        }),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil dikirim!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); 
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal mengirim: ${response.statusCode}"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error Koneksi: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String workerName = widget.jobData['worker_name'] ?? "AFP 2";
    String serviceTime = widget.jobData['time'] ?? "2025-12-30 7:08 AM";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Services"),
        backgroundColor: const Color(0xFF6395F8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Service Time"),
            _buildReadOnlyField(serviceTime),
            const SizedBox(height: 15),

            _buildLabel("Worker"),
            _buildReadOnlyField(workerName),
            const SizedBox(height: 15),

            _buildLabel("Jumlah Pipa Diperbaiki"),
            TextField(
              controller: _jumlahPipaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Jumlah",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 15),

            _buildLabel("Tingkat Kesulitan"),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              items: ["Mudah", "Sedang", "Sulit"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedDifficulty = val!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),

            _buildLabel("Status"),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: ["Accepted", "On Process", "Finished"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedStatus = val!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.green[100],
              child: Text(
                "Total Biaya: Rp ${_calculateCost()}",
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSending ? null : _submitService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6395F8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isSending 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(text),
    );
  }
}