import 'package:flutter/material.dart';

import 'worker_page.dart';
import 'profile_worker.dart';

import '../../domain/entities/worker.dart';
import '../../domain/usecase/accjob_worker.dart';
import '../../domain/repositories/worker_repository.dart';

class FakeWorkerRepository implements WorkerRepository {
  final Worker _worker = Worker(
    idWorker: 1,
    idAccount: 1,
    role: 'Plumber',
    statusAvailable: true,
  );

  @override
  Future<Worker> getWorkerById(int idWorker) async => _worker;

  @override
  Future<List<Worker>> getAvailableWorkers() async => [_worker];

  @override
  Future<void> updateWorkerStatus({
    required int idWorker,
    required bool statusAvailable,
  }) async {}
}

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int _currentIndex = 0;

  late final Worker worker;
  late final AccJobWorker accJobWorker;

  @override
  void initState() {
    super.initState();
    final repo = FakeWorkerRepository();
    worker = repo._worker;
    accJobWorker = AccJobWorker(repo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      body: _buildTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xff6ea0ff),
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTab() {
    switch (_currentIndex) {
      case 0:
        return _homeDashboard();
      case 1:
        return const Center(child: Text('History Worker'));
      case 2:
        return const ProfileWorkerPage();
      default:
        return const SizedBox();
    }
  }

  Widget _homeDashboard() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _workerCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkerPage(
                        worker: worker,
                        accJobWorker: accJobWorker,
                      ),
                    ),
                  );
                },
                child: const Text('Take Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Worker ID: ${worker.idWorker}'),
                Text('Role: ${worker.role}'),
                Text(worker.statusAvailable ? 'Available' : 'Busy'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
