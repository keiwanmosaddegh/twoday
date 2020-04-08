import 'dart:collection';

class Habit {
  String habitName;
  bool state = false;
  ListQueue<DateTime> checkboxHistory = ListQueue();

  Habit(String habitName) {
    this.habitName = habitName;
  }

  void addCheckboxTickDate(DateTime date) {
    if(checkboxHistory.length > 3) {
      checkboxHistory.removeLast();
    }
    checkboxHistory.addFirst(date);
  }

  void removeCheckboxTickDate() {
    checkboxHistory.removeFirst();
  }
}