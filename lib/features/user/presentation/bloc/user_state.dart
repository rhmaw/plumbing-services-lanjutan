import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}


class OrderHistoryLoaded extends UserState {
  final List<BookingServiceEntity> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}


class UserSuccess extends UserState {
  final String message;

  const UserSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
