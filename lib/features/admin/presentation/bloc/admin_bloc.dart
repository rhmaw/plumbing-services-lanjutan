import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/accept_registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_salary_worker.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_worker_detail.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/reject_registration.dart';

import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetRegistrations getRegistrations;
  final AcceptRegistration acceptRegistration;
  final RejectRegistration rejectRegistration;
  final GetSalaryWorker getSalaryWorker;
  final GetWorkerDetail getWorkerDetail;

  AdminBloc({
    required this.getRegistrations,
    required this.acceptRegistration,
    required this.rejectRegistration,
    required this.getSalaryWorker,
    required this.getWorkerDetail,
  }) : super(AdminInitial()) {
    on<LoadRegistrationsEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        final data = await getRegistrations();
        emit(RegistrationLoaded(data));
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });

    // on<LoadWorkerDetailEvent>((event, emit) async {
    //   emit(AdminLoading());
    //   try {
    //     final worker = await getWorkerDetail(event.registrationId);
    //     emit(WorkerDetailLoaded(worker));
    //   } catch (e) {
    //     emit(AdminError(e.toString()));
    //   }
    // });

    on<AcceptRegistrationEvent>((event, emit) async {
      emit(AdminLoading());
      await acceptRegistration(event.registrationId);
      final data = await getRegistrations();
      emit(RegistrationLoaded(data));
    });

    on<RejectRegistrationEvent>((event, emit) async {
      emit(AdminLoading());
      await rejectRegistration(event.registrationId);
      final data = await getRegistrations();
      emit(RegistrationLoaded(data));
    });

    on<LoadSalaryWorkerEvent>((event, emit) async {
      emit(AdminLoading());
      final salary = await getSalaryWorker(event.workerId);
      emit(SalaryLoaded(salary));
    });
  }
}
