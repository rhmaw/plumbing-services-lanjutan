import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/usecase/booking_service.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/usecase/get_order_history.dart';


import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final BookingWorker bookingWorker;
  final GetOrderHistory getOrderHistory;

  UserBloc({
    required this.bookingWorker,
    required this.getOrderHistory,
  }) : super(UserInitial()) {

    on<GetOrderHistoryEvent>(_onGetOrderHistory);
    on<CreateBookingEvent>(_onCreateBooking);
  }

  Future<void> _onGetOrderHistory(
    GetOrderHistoryEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final result = await getOrderHistory.execute(event.status);
      emit(UserLoaded(result));
    } catch (e) {
      emit(const UserError('Gagal mengambil data order'));
    }
  }

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await bookingWorker.execute(event.booking);
      emit(const UserSuccess('Booking berhasil dibuat'));
    } catch (e) {
      emit(const UserError('Booking gagal'));
    }
  }
}
