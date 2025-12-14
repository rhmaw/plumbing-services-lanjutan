import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ValueNotifier<String> selectedCategory = ValueNotifier<String>(
    'default',
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      //bottomNavigationBar: const BottomNav(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              const Row(
                children: [
                  CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo selamat datang',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff1F5EFF), // 🔵 biru
                        ),
                      ),
                      Text(
                        'Rahma',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F5EFF), // 🔵 biru
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// DROPDOWN
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xffEAF2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: selectedCategory,
                  builder: (context, value, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: value,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'default',
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
                          selectedCategory.value = val!;
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
