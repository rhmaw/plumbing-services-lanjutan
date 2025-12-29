import 'package:flutter/material.dart';

class BookingServicePage extends StatelessWidget {
  BookingServicePage({super.key});

  final ValueNotifier<String?> selectedService = ValueNotifier(null);
  final ValueNotifier<DateTime?> selectedDate = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> selectedTime = ValueNotifier(null);

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Services'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
               
                      const Text(
                        'Pilih Jenis Layanan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String?>(
                        valueListenable: selectedService,
                        builder: (context, value, _) {
                          return DropdownButtonFormField<String>(
                            value: value,
                            hint: const Text('Pilih Jenis Layanan'),
                            decoration: InputDecoration(
                              border: _border(),
                              enabledBorder: _border(),
                              focusedBorder: _border(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Perbaikan Kebocoran',
                                child: Text('Perbaikan Kebocoran'),
                              ),
                              DropdownMenuItem(
                                value: 'Instalasi Pipa',
                                child: Text('Instalasi Pipa'),
                              ),
                              DropdownMenuItem(
                                value: 'Pembersihan Saluran Mampet',
                                child: Text('Pembersihan Saluran Mampet'),
                              ),
                              DropdownMenuItem(
                                value: 'Perawatan Saluran',
                                child: Text('Perawatan Saluran'),
                              ),
                            ],
                            onChanged: (val) {
                              selectedService.value = val;
                            },
                          );
                        },
                
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
                      const SizedBox(height: 16),

                      
                      const Text(
                        'Tanggal Layanan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Tanggal Layanan',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: _border(),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            selectedDate.value = picked;
                            dateController.text =
                                picked.toString().split(' ')[0];
                          }
                        },
                      ),

                      const SizedBox(height: 16),

              
                      const Text(
                        'Waktu Layanan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Waktu Layanan',
                          suffixIcon: const Icon(Icons.access_time),
                          border: _border(),
                        ),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            selectedTime.value = picked;
                            timeController.text =
                                picked.format(context);
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rincian Harga',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('• Mudah   Rp. 50.000'),
                            Text('• Sedang Rp. 70.000'),
                            Text('• Sulit   Rp. 100.000'),
                            SizedBox(height: 6),
                            Text(
                              '*Harga final dapat berubah berdasarkan kondisi lapangan.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order berhasil dikirim'),
                              ),
                            );
                          },
                          child: const Text(
                            'Order Now',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                    
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
