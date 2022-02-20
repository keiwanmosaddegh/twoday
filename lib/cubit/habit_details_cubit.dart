import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twoday/models/habitDetails.dart';
import 'package:twoday/services/Database.dart';

part 'habit_details_state.dart';

class HabitDetailsCubit extends Cubit<HabitDetailsState> {
  HabitDetailsCubit() : super(HabitDetailsInitial());

  Future<void> getHabitDetails(String habitId) async {
    try {
      emit(HabitDetailsLoading());
      final habitDetailsResult =
          await DBProvider.db.getHabitDetails(habitId: habitId);
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
      await DBProvider.db.toggleHabitEntry(habitId, value, dateTime);
      final habitDetailsResult =
          await DBProvider.db.getHabitDetails(habitId: habitId);
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
