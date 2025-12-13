import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}


class GetOrderHistoryEvent extends UserEvent {
  final String status;

  const GetOrderHistoryEvent(this.status);

  @override
  List<Object?> get props => [status];
}


class CreateBookingEvent extends UserEvent {
  final BookingServiceEntity booking;

  const CreateBookingEvent(this.booking);

  @override
  List<Object?> get props => [booking];
}
