import 'package:equatable/equatable.dart';
import 'package:twodayrule/models/habit.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class HabitsLoaded extends HabitEvent {}

class HabitAdded extends HabitEvent {
  final Habit habit;

  const HabitAdded(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitAdded { habit: $habit }';
}

class HabitUpdated extends HabitEvent {
  final Habit habit;

  const HabitUpdated(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitUpdated { habit: $habit }';
}

class HabitDeleted extends HabitEvent {
  final Habit habit;

  const HabitDeleted(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitDeleted { habit: $habit }';
}

class HabitReseted extends HabitEvent {
  final int days;

  const HabitReseted(this.days);

  @override
  List<Object> get props => [days];

  @override
  String toString() => 'HabitsReseted { Days since last reset: $days }';
}
