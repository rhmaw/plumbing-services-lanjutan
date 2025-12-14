import 'package:flutter/material.dart';
import 'features/worker/presentation/pages/worker_page.dart';
import 'features/worker/domain/entities/worker.dart';
import 'features/worker/domain/repositories/worker_repository.dart';
import 'features/worker/domain/usecase/accjob_worker.dart';

class _FakeWorkerRepository implements WorkerRepository {
  final Worker sampleWorker = Worker(
    idWorker: 1,
    idAccount: 1,
    role: 'Plumber',
    statusAvailable: true,
  );

  @override
  Future<Worker> getWorkerById(int idWorker) async => sampleWorker;

  @override
  Future<List<Worker>> getAvailableWorkers() async => [sampleWorker];

  @override
  Future<void> updateWorkerStatus({required int idWorker, required bool statusAvailable}) async {
    // simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

void main() {
  final repo = _FakeWorkerRepository();
  final acc = AccJobWorker(repo);
  final worker = repo.sampleWorker;

  runApp(MyApp(worker: worker, accJobWorker: acc));
}

class MyApp extends StatelessWidget {
  final Worker worker;
  final AccJobWorker accJobWorker;

  const MyApp({super.key, required this.worker, required this.accJobWorker});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plumbing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xfff4f6f8),
      ),
      home: WorkerPage(worker: worker, accJobWorker: accJobWorker),
    );
  }
}
