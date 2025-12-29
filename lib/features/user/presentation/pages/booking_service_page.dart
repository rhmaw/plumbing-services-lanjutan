import 'package:flutter/material.dart';

class BookingServicePage extends StatefulWidget {
  const BookingServicePage({super.key});

  @override
  State<BookingServicePage> createState() => _BookingServicePageState();
}

class _BookingServicePageState extends State<BookingServicePage> {
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Services'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Jenis Layanan'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedService,
              hint: const Text('Jenis Layanan'),
              items: const [
                DropdownMenuItem(
                  value: 'Ganti Pipa',
                  child: Text('Ganti Pipa'),
                ),
                DropdownMenuItem(
                  value: 'Service AC',
                  child: Text('Service AC'),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedService = value);
              },
            ),
            const SizedBox(height: 16),

            const Text('Tanggal Layanan'),
            const SizedBox(height: 8),
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Tanggal Layanan',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    dateController.text = picked.toString().split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            const Text('Waktu Layanan'),
            const SizedBox(height: 8),
            TextFormField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Waktu Layanan',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                    timeController.text = picked.format(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
