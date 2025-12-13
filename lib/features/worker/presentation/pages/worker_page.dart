import 'package:flutter/material.dart';
import '../../domain/entities/worker.dart';
import '../../domain/usecase/accjob_worker.dart';

/// Presentation Layer - Worker Take Services Page
/// Clean Architecture + Responsive Design
class WorkerPage extends StatefulWidget {
  final Worker worker;
  final AccJobWorker accJobWorker;

  const WorkerPage({
    super.key,
    required this.worker,
    required this.accJobWorker,
  });

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  String tingkatKesulitan = 'Mudah';
  String status = 'Accepted';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        return Scaffold(
          backgroundColor: const Color(0xfff4f6f8),
          appBar: AppBar(
            backgroundColor: const Color(0xff6ea0ff),
            title: const Text('Take Services'),
            leading: const BackButton(),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Service Time',
                      hint: '2025-11-19 10:29',
                    ),
                    _buildTextField(
                      label: 'Worker ID',
                      hint: widget.worker.idWorker.toString(),
                    ),
                    _buildTextField(
                      label: 'Jumlah Pipa Diperbaiki',
                      hint: 'Jumlah',
                    ),
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
                        onPressed: _onSubmit,
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
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
      },
    );
  }

  Future<void> _onSubmit() async {
    if (status == 'Accepted') {
      await widget.accJobWorker.acceptJob(widget.worker);
    } else if (status == 'Reject') {
      await widget.accJobWorker.rejectJob(widget.worker);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: hint,
          enabled: false,
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
