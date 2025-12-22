import 'package:flutter/material.dart';

class BookingServicesPage extends StatefulWidget {
  final VoidCallback onOrderNow;
  const BookingServicesPage({super.key, required this.onOrderNow});

  @override
  State<BookingServicesPage> createState() => _BookingServicesPageState();
}

class _BookingServicesPageState extends State<BookingServicesPage> {
  String service = "Installasi Pipa";
  DateTime? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Booking Services", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          DropdownButtonFormField(
            value: service,
            items: const [
              DropdownMenuItem(value: "Installasi Pipa", child: Text("Installasi Pipa")),
              DropdownMenuItem(value: "Pembersihan Saluran", child: Text("Pembersihan Saluran")),
              DropdownMenuItem(value: "Perawatan Saluran", child: Text("Perawatan Saluran")),
            ],
            onChanged: (v) => setState(() => service = v ?? service),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: DateTime.now(),
              );
              setState(() => date = d);
            },
            child: Text(date == null ? "Tanggal Layanan" : "Tanggal: ${date!.day}/${date!.month}/${date!.year}"),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              setState(() => time = t);
            },
            child: Text(time == null ? "Waktu Layanan" : "Waktu: ${time!.format(context)}"),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onOrderNow,
              child: const Text("Order Now"),
            ),
          )
        ],
      ),
    );
  }
}