import 'package:flutter/material.dart';

class WorkerPage extends StatefulWidget {
  const WorkerPage({super.key});

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  String tingkatKesulitan = 'Mudah';
  String status = 'Accepted';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xff6ea0ff),
        title: const Text('Take Services'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'Service Time', hint: '2025-11-19 10:29'),
            _buildTextField(label: 'Worker', hint: 'Banu'),
            _buildTextField(label: 'Jumlah Pipa Diperbaiki', hint: 'Jumlah'),
            const SizedBox(height: 12),
            const Text('Tingkat Kesulitan'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: tingkatKesulitan,
              items: const [
                DropdownMenuItem(value: 'Mudah', child: Text('Mudah')),
                DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                DropdownMenuItem(value: 'Sulit', child: Text('Sulit')),
              ],
              onChanged: (v) => setState(() => tingkatKesulitan = v!),
              decoration: _decoration(),
            ),
            const SizedBox(height: 12),
            const Text('Status'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'Accepted', child: Text('Accepted')),
                DropdownMenuItem(value: 'Reject', child: Text('Reject')),
                DropdownMenuItem(value: 'Finish', child: Text('Finish')),
              ],
              onChanged: (v) => setState(() => status = v!),
              decoration: _decoration(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Total Biaya: 0'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6ea0ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xff6ea0ff),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: hint,
          decoration: _decoration(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
