import 'package:flutter/material.dart';

class AdminWorkerDetail extends StatelessWidget {
  const AdminWorkerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Detail"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text("Worker ${index + 1}"),
              subtitle: const Text("Status: Active"),
              trailing: const Icon(Icons.visibility, color: Colors.pinkAccent),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
