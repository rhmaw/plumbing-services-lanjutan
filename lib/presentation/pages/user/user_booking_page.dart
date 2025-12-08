import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserBookingPage extends StatefulWidget {
  const UserBookingPage({super.key});

  @override
  State<UserBookingPage> createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedService;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController problemController = TextEditingController();

  bool isLoading = false;

  // ==============================
  // KIRIM BOOKING KE BACKEND API
  // ==============================
  Future<void> submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://your-api.com/booking/create"),
        body: {
          "service": selectedService,
          "date": dateController.text,
          "description": problemController.text,
          "user_id": "1", // sesuaikan
        },
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSuccess(data["message"] ?? "Booking berhasil!");
      } else {
        _showError("Gagal melakukan booking");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Terjadi kesalahan: $e");
    }
  }

  // POPUP SUCCESS
  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sukses"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // POPUP ERROR
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // PILIH TANGGAL
  Future<void> pickDate() async {
    final DateTime? result = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (result != null) {
      dateController.text = "${result.year}-${result.month}-${result.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Jasa"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ==== DROPDOWN SERVICE ====
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Pilih Layanan",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedService,
                  items: const [
                    DropdownMenuItem(
                      value: "Tukang Ledeng",
                      child: Text("Tukang Ledeng"),
                    ),
                    DropdownMenuItem(
                      value: "Tukang Listrik",
                      child: Text("Tukang Listrik"),
                    ),
                    DropdownMenuItem(
                      value: "Service AC",
                      child: Text("Service AC"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedService = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Harus pilih layanan" : null,
                ),

                const SizedBox(height: 20),

                // ==== PICK DATE ====
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal Booking",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: pickDate,
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Tanggal harus diisi" : null,
                ),

                const SizedBox(height: 20),

                // ==== MASALAH ====
                TextFormField(
                  controller: problemController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Masalah",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
                ),

                const SizedBox(height: 30),

                // ==== SUBMIT BUTTON ====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitBooking,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      backgroundColor: Colors.blue,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Konfirmasi Booking",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
