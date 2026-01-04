import 'package:equatable/equatable.dart';

abstract class WorkerEvent extends Equatable {
  const WorkerEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkers extends WorkerEvent {}

class SearchWorkers extends WorkerEvent {
  final String query;
  const SearchWorkers(this.query);

  @override
  List<Object> get props => [query];
}