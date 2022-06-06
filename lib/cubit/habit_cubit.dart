import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/services/habit_repository.dart';

part 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitsLoading());

  Future<void> getAllHabits() async {
    try {
      emit(HabitsLoading());
      final habits = await HabitRepository.repo.getAllHabits();
      emit(HabitsLoaded(habits));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await HabitRepository.repo.deleteHabitById(habit.id);
      final habits = await HabitRepository.repo.getAllHabits();
      emit(HabitsLoaded(habits));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> createHabit(Habit habit) async {
    try {
      await HabitRepository.repo.createHabit(habit);
      final habits = await HabitRepository.repo.getAllHabits();
      emit(HabitsLoaded(habits));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await HabitRepository.repo.updateHabit(habit);
      final habits = await HabitRepository.repo.getAllHabits();
      emit(HabitsLoaded(habits));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> toggleHabitEntry(
      {String habitId, bool value, DateTime dateTime}) async {
    try {
      await HabitRepository.repo.toggleHabitEntry(habitId, value, dateTime);
      final habits = await HabitRepository.repo.getAllHabits();
      emit(HabitsLoaded(habits));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }
}
