import 'package:flutter/material.dart';
import 'features/worker/presentation/pages/worker_home_page.dart';


void main() {
runApp(const MyApp());
}


class MyApp extends StatelessWidget {
const MyApp({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
home: const WorkerHomePage(),
);
}
}