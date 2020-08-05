import 'homepage/model/habit.dart';

class FakeRepo {
  List<Habit> _habitList = [
    Habit("habit1"),
    Habit("habit2"),
    Habit("habit3"),
    Habit("habit4"),
    Habit("habit5"),
  ];

  FakeRepo();

  List<Habit> get habitList => _habitList;

  updateHabits(List<Habit> updatedHabits) {
    _habitList = updatedHabits;
  }
}