part of 'details_bloc.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object> get props => [];
}

class DetailsLoadInProgress extends DetailsState {}

class DetailsLoadSuccess extends DetailsState {
  final Habit habit;

  const DetailsLoadSuccess(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'DetailsLoadSuccess { habit: $habit }';
}

class DetailsLoadFailure extends DetailsState {}


