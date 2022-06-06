import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twoday/models/habitDetails.dart';
import 'package:twoday/services/habit_repository.dart';

part 'habit_details_state.dart';

class HabitDetailsCubit extends Cubit<HabitDetailsState> {
  HabitDetailsCubit() : super(HabitDetailsInitial());

  Future<void> getQuarterlyStatisticsOfHabit(String habitId) async {
    try {
      emit(HabitDetailsLoading());
      final habitDetailsResult = await HabitRepository.repo
          .getQuarterlyStatisticsOfHabit(habitId: habitId);
      final habitDetails = HabitDetails(
          habitId: habitId,
          statistics: habitDetailsResult["statistics"],
          entries: habitDetailsResult["entries"]);
      emit(HabitDetailsLoaded(habitDetails));
    } catch (e) {
      emit(HabitDetailsError(e.toString()));
    }
  }

  Future<void> toggleHabitEntry(
      {String habitId, bool value, DateTime dateTime}) async {
    try {
      await HabitRepository.repo.toggleHabitEntry(habitId, value, dateTime);
      final habitDetailsResult = await HabitRepository.repo
          .getQuarterlyStatisticsOfHabit(habitId: habitId);
      final habitDetails = HabitDetails(
          habitId: habitId,
          statistics: habitDetailsResult["statistics"],
          entries: habitDetailsResult["entries"]);
      emit(HabitDetailsLoaded(habitDetails));
    } catch (e) {
      emit(HabitDetailsError(e.toString()));
    }
  }
}
