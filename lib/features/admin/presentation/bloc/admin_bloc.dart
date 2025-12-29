import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/accept_registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_admin_profile.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_salary_worker.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/get_worker_detail.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/usecase/reject_registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_event.dart';
import 'package:plumbing_services_pml_kel4/features/admin/presentation/bloc/admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetRegistrations getRegistrations;
  final AcceptRegistration acceptRegistration;
  final RejectRegistration rejectRegistration;
  final GetSalaryWorker getSalaryWorker;
  final GetWorkerDetail getWorkerDetail;
  final GetAdminProfile getAdminProfile;
  final List<Registration> _acceptedRegistrations = [];

  AdminBloc({
    required this.getRegistrations,
    required this.acceptRegistration,
    required this.rejectRegistration,
    required this.getSalaryWorker,
    required this.getWorkerDetail,
    required this.getAdminProfile,
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

    on<LoadWorkerDetailEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        final worker = await getWorkerDetail(event.registrationId.toString());
        emit(WorkerDetailLoaded(worker));
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });

    on<AcceptRegistrationEvent>((event, emit) async {
      emit(AdminLoading());
      await acceptRegistration(event.registrationId.toString());
      final data = await getRegistrations();

      final accepted = data.firstWhere(
        (r) => r.registrationId == event.registrationId,
      );
      _acceptedRegistrations.add(accepted);

      emit(RegistrationLoaded(data));
    });

    on<RejectRegistrationEvent>((event, emit) async {
      emit(AdminLoading());
      await rejectRegistration(event.registrationId.toString());
      final data = await getRegistrations();
      emit(RegistrationLoaded(data));
    });

    on<LoadSalaryWorkerEvent>((event, emit) async {
      emit(AdminLoading());
      final salary = await getSalaryWorker(event.workerId.toString());
      emit(SalaryLoaded(salary));
    });

    on<LoadAdminProfileEvent>((event, emit) async {
      emit(AdminLoading());
      final admin = await getAdminProfile(event.adminId.toString());
      emit(AdminProfileLoaded(admin));
    });

    on<LoadAcceptedRegistrationsEvent>((event, emit) async {
      emit(AdminLoading());
      emit(AcceptedRegistrationsLoaded(List.from(_acceptedRegistrations)));
    });
  }
}
