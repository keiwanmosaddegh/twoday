part of 'details_bloc.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsLoaded extends DetailsEvent {
  final Habit habit;

  const DetailsLoaded(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'DetailsLoaded { habit: $habit }';
}

class DetailsUpdated extends DetailsEvent {
  final Habit habit;

  const DetailsUpdated(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'DetailsUpdated { habit: $habit }';
}


