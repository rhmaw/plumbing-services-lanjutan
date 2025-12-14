import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/user/presentation/pages/booking_service_page.dart';
import 'features/user/presentation/pages/order_history_page.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/domain/usecase/booking_service.dart';
import 'features/user/domain/usecase/get_order_history.dart';
import 'features/user/domain/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(
        bookingWorker: BookingWorker(
          repository: DummyUserRepository(),
        ),
        getOrderHistory: GetOrderHistory(
          repository: DummyUserRepository(),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plumbing Services',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainNavigationPage(),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BookingServicePage(),
    const OrderHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}


class DummyUserRepository implements UserRepository {
  @override
  Future<void> createBooking(dynamic booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<dynamic>> getOrderHistory(String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}
