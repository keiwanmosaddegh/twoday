import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twodayrule/models/habitDetails.dart';
import 'package:twodayrule/services/Database.dart';

part 'habit_details_state.dart';

class HabitDetailsCubit extends Cubit<HabitDetailsState> {
  HabitDetailsCubit() : super(HabitDetailsInitial());

  Future<void> getHabitDetails(String habitId) async {
    try {
      emit(HabitDetailsLoading());
      final habitDetailsResult = await DBProvider.db.getHabitDetails(habitId);
      final habitDetails =
          HabitDetails(habitId: habitId, quarterStatistics: habitDetailsResult);
      emit(HabitDetailsLoaded(habitDetails));
    } catch (e) {
      emit(HabitDetailsError(e.toString()));
    }
  }
}
