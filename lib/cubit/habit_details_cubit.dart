import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twoday/models/habitDetails.dart';
import 'package:twoday/services/Database.dart';

part 'habit_details_state.dart';

class HabitDetailsCubit extends Cubit<HabitDetailsState> {
  HabitDetailsCubit() : super(HabitDetailsInitial());

  Future<void> getHabitDetails({String habitId, int year}) async {
    try {
      emit(HabitDetailsLoading());
      final habitDetailsResult =
          await DBProvider.db.getHabitDetails(habitId: habitId, year: year);
      final habitDetails = HabitDetails(
          habitId: habitId,
          year: habitDetailsResult["year"],
          quarterStatistics: habitDetailsResult["quarterStatistics"]);
      emit(HabitDetailsLoaded(habitDetails));
    } catch (e) {
      emit(HabitDetailsError(e.toString()));
    }
  }
}
