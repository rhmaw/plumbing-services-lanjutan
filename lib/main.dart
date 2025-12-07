import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/auth_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
    );
  }
} 
