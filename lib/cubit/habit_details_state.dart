part of 'habit_details_cubit.dart';

abstract class HabitDetailsState extends Equatable {
  const HabitDetailsState();

  @override
  List<Object> get props => [];
}

class HabitDetailsInitial extends HabitDetailsState {}

class HabitDetailsLoading extends HabitDetailsState {}

class HabitDetailsLoaded extends HabitDetailsState {
  final HabitDetails habitDetails;

  const HabitDetailsLoaded(this.habitDetails);

  @override
  List<Object> get props => [habitDetails];

  @override
  String toString() => 'HabitDetailsLoaded { habitDetails: $habitDetails }';
}

class HabitDetailsError extends HabitDetailsState {
  final String exceptionMessage;

  const HabitDetailsError(this.exceptionMessage);
}
