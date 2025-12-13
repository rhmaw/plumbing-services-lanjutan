// class AdminRepositoryImpl implements AdminRepository {
//   final AdminRemoteDataSource remoteDataSource;

//   AdminRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<List<Registration>> getRegistrations() async {
//     final result = await remoteDataSource.getRegistrations();
//     return result;
//   }

//   @override
//   Future<void> acceptRegistration(String registrationId) async {
//     await remoteDataSource.acceptRegistration(registrationId);
//   }

//   @override
//   Future<void> rejectRegistration(String registrationId) async {
//     await remoteDataSource.rejectRegistration(registrationId);
//   }

//   @override
//   Future<Worker> getWorkerDetail(String registrationId) async {
//     final result = await remoteDataSource.getWorkerDetail(registrationId);
//     return result;
//   }

//   @override
//   Future<int> GetSalaryWorker(String workerId) async {
//     final result = await remoteDataSource.getSalaryWorker(workerId);
//     return result;
//   }
// }
