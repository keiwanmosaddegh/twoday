part of 'habit_cubit.dart';

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitsLoading extends HabitState {}

class HabitsLoaded extends HabitState {
  final List<Habit> habits;

  const HabitsLoaded([this.habits]);

  @override
  List<Object> get props => [habits];

  @override
  String toString() => 'HabitsLoaded { habits: $habits }';
}

class HabitsError extends HabitState {
  final String exceptionMessage;

  const HabitsError(this.exceptionMessage);
}
