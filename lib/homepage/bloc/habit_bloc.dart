import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';
import 'package:twodayrule/fakeRepo.dart';
import 'package:twodayrule/homepage/model/habit.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  FakeRepo fakeRepo;

  HabitBloc() {
    this.fakeRepo = new FakeRepo();
  }

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
    }
  }

  Stream<HabitState> _mapHabitsLoadedToState() async* {
    final habits = this.fakeRepo.habitList;
    yield HabitsLoadSuccess(habits);
  }

  Stream<HabitState> _mapHabitAddedToState(HabitAdded event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> updatedHabits =
          List.from((state as HabitsLoadSuccess).habits)..add(event.habit);
      yield HabitsLoadSuccess(updatedHabits);
      fakeRepo.updateHabits(updatedHabits);
    }
  }

  Stream<HabitState> _mapHabitUpdatedToState(HabitUpdated event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> updatedHabits =
          (state as HabitsLoadSuccess).habits.map((habit) {
        return habit.task == event.habit.task ? event.habit : habit;
      }).toList();
      yield HabitsLoadSuccess(updatedHabits);
      fakeRepo.updateHabits(updatedHabits);
    }
  }

  Stream<HabitState> _mapHabitDeletedToState(HabitDeleted event) async* {
    if (state is HabitsLoadSuccess) {
      final updatedHabits = (state as HabitsLoadSuccess)
          .habits
          .where((habit) => habit.task != event.habit.task)
          .toList();
      yield HabitsLoadSuccess(updatedHabits);
      fakeRepo.updateHabits(updatedHabits);
    }
  }
}
