import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:http/http.dart' as http; // Untuk HTTP request
import 'dart:convert'; // Untuk decode JSON
import 'package:flutter_application_1/constants.dart'; // Sesuaikan sesuai projectmu
import 'package:shared_preferences/shared_preferences.dart'; // Token JWT

class TakeServicesPage extends StatefulWidget {
  final String idHistory;

  const TakeServicesPage({super.key, required this.idHistory});

  @override
  State<TakeServicesPage> createState() => _TakeServicesPageState();
}

class _TakeServicesPageState extends State<TakeServicesPage> {
  late TextEditingController _timeController;
  late TextEditingController _workerController;

  String _status = "Accepted";
  String _workerName = 'Jane Smit'; // Default jika tidak ditemukan

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkerName();
    var dateTime = DateTime.now();
    _timeController = TextEditingController(
      text:
          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}",
    );
  }

  Future<void> _updateJobStatus() async {
    final url = Uri.parse('$apiBaseUrl/worker/job/update/${widget.idHistory}');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Token tidak ditemukan. Silakan login ulang."),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
      return;
    }

    final body = {
      'taken_time': _timeController.text,
      'status': _status.toLowerCase(), // accepted, processing, done
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Status berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );

        // Kirim hasil kembali ke halaman sebelumnya
        Navigator.pop(context, {'status': _status});
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Autentikasi gagal. Silakan login ulang."),
            backgroundColor: Colors.red,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        final responseData = json.decode(response.body);
        String message = "Gagal mengupdate status pekerjaan.";

        if (responseData.containsKey('message')) {
          message = responseData['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange.shade800,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kesalahan jaringan. Periksa koneksi Anda."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          _timeController.text.isNotEmpty
              ? DateTime.parse(_timeController.text)
              : DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _timeController.text.isNotEmpty
              ? DateTime.parse(_timeController.text)
              : DateTime.now(),
        ),
      );

      if (selectedTime != null) {
        // Gabungkan tanggal dan waktu ke dalam satu string
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _timeController.text =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
        });
      }
    }
  }

  Future<void> _loadWorkerName() async {
    final prefs = await SharedPreferences.getInstance();
    _workerController = TextEditingController(text: prefs.getString('name'));
    setState(() {
      _workerName = prefs.getString('name') ?? 'Worker';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Take Services"),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Time
                    Text(
                      "Service Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => {},
                      child: IgnorePointer(
                        child: TextField(
                          controller: _timeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "e.g. 2025-05-27 10:00",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Worker Name
                    Text(
                      "Worker",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _workerController,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Dropdown
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _status,
                          isExpanded: true,
                          items:
                              ['Accepted', 'Pending', 'Finished']
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _status = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateJobStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : const Text("Send"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}