import 'package:equatable/equatable.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<dynamic> history;
  final List<dynamic> filteredHistory;

  const HistoryLoaded({required this.history, required this.filteredHistory});

  @override
  List<Object> get props => [history, filteredHistory];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
