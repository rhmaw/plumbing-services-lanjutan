import 'package:plumbing_services_pml_kel4/features/admin/data/data_source/admin_remote_data_source.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/admin.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/worker.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Registration>> getRegistrations() async {
    return await remoteDataSource.getRegistrations();
  }

  @override
  Future<void> acceptRegistration(String registrationId) async {
    await remoteDataSource.acceptRegistration(registrationId);
  }

  @override
  Future<void> rejectRegistration(String registrationId) async {
    await remoteDataSource.rejectRegistration(registrationId);
  }

  @override
  Future<Worker> getWorkerDetail(String registrationId) async {
    return await remoteDataSource.getWorkerDetail(registrationId);
  }

  @override
  Future<int> getSalaryWorker(String workerId) async {
    return await remoteDataSource.getSalaryWorker(workerId);
  }

  @override
  Future<Admin> getAdminProfile(String adminId) async {
    return await remoteDataSource.getAdminProfile(adminId);
  }
}
