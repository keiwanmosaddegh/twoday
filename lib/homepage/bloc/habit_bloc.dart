import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:twodayrule/Database.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';
import 'package:twodayrule/homepage/model/habit.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  @override
  HabitState get initialState => HabitsLoadInProgress();

  @override
  Stream<HabitState> mapEventToState(HabitEvent event) async* {
    if (event is HabitsLoaded) {
      yield* _mapHabitsLoadedToState();
    } else if (event is HabitAdded) {
      yield* _mapHabitAddedToState(event);
    } else if (event is HabitUpdated) {
      yield* _mapHabitUpdatedToState(event);
    } else if (event is HabitDeleted) {
      yield* _mapHabitDeletedToState(event);
    } else if (event is HabitReseted) {
      yield* _mapHabitResetedToState(event);
    }
  }

  Stream<HabitState> _mapHabitsLoadedToState() async* {
    final habits = await DBProvider.db.getAllHabits();
    yield HabitsLoadSuccess(habits);
  }

  Stream<HabitState> _mapHabitAddedToState(HabitAdded event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> updatedHabits =
          List.from((state as HabitsLoadSuccess).habits)..add(event.habit);
      yield HabitsLoadSuccess(updatedHabits);
      DBProvider.db.insertHabit(event.habit);
    }
  }

  Stream<HabitState> _mapHabitUpdatedToState(HabitUpdated event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> updatedHabits =
          (state as HabitsLoadSuccess).habits.map((habit) {
        return habit.id == event.habit.id ? event.habit : habit;
      }).toList();
      yield HabitsLoadSuccess(updatedHabits);
      DBProvider.db.updateHabit(event.habit);
    }
  }

  Stream<HabitState> _mapHabitDeletedToState(HabitDeleted event) async* {
    if (state is HabitsLoadSuccess) {
      final updatedHabits = (state as HabitsLoadSuccess)
          .habits
          .where((habit) => habit.id != event.habit.id)
          .toList();
      yield HabitsLoadSuccess(updatedHabits);
      DBProvider.db.deleteHabit(event.habit.id);
    }
  }

  Stream<HabitState> _mapHabitResetedToState(HabitReseted event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> resetedHabits =
          (state as HabitsLoadSuccess).habits.map((habit) {
        var newHabit = habit.resetHabit(event.days);
        DBProvider.db.updateHabit(newHabit);
        return newHabit;
      }).toList();
      yield HabitsLoadSuccess(resetedHabits);
    }
  }
}
