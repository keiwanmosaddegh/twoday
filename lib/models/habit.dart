import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twodayrule/services/Database.dart';

class Habit extends Equatable {
  final String id;
  final String task;
  final bool complete;
  final int currentStreak;
  final int longestStreak;
  final int daysSinceLastComplete;
  final int prevDaysSinceLastComplete;

  Habit(this.task,
      {this.complete = false,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.daysSinceLastComplete = 4,
      this.prevDaysSinceLastComplete = 0,
      String id})
      : this.id = id ?? UniqueKey().toString();

  int updateStreak(bool value) {
    if (value != null) {
      if (value) {
        return this.currentStreak + 1;
      } else {
        return this.currentStreak - 1;
      }
    }
    return this.currentStreak;
  }

  int defDaysSinceLastComplete(bool value) {
    if (value) {
      return 0;
    } else {
      return this.prevDaysSinceLastComplete;
    }
  }

  Habit copyWith({
    String id,
    String task,
    bool complete,
    int currentStreak,
    int longestStreak,
    int daysSinceLastComplete,
    int prevDaysSinceLastComplete,
  }) {
    return Habit(
      task ?? this.task,
      id: id ?? this.id,
      complete: complete ?? this.complete,
      currentStreak: currentStreak ?? updateStreak(complete),
      longestStreak: longestStreak ?? this.longestStreak,
      daysSinceLastComplete:
          daysSinceLastComplete ?? defDaysSinceLastComplete(complete),
      prevDaysSinceLastComplete:
          prevDaysSinceLastComplete ?? this.daysSinceLastComplete,
    );
  }

  Habit resetHabit(int days) {
    var overdue = currentStreak != 0 && this.daysSinceLastComplete + days > 2;

    return Habit(
      this.task,
      id: this.id,
      complete: false,
      currentStreak: overdue ? 0 : this.currentStreak,
      longestStreak: overdue && this.currentStreak > this.longestStreak
          ? this.currentStreak
          : this.longestStreak,
      daysSinceLastComplete: this.daysSinceLastComplete + days,
      prevDaysSinceLastComplete: this.daysSinceLastComplete,
    );
  }

  Map<String, dynamic> toMap() => {
        DBProvider.COLUMN_ID: id,
        DBProvider.COLUMN_TASK: task,
        DBProvider.COLUMN_COMPLETE: complete ? 1 : 0,
        DBProvider.COLUMN_CURRENTSTREAK: currentStreak,
        DBProvider.COLUMN_LONGESTSTREAK: longestStreak,
        DBProvider.COLUMN_DAYSSINCELASTCOMPLETE: daysSinceLastComplete,
        DBProvider.COLUMN_PREVDAYSSINCELASTCOMPLETE: prevDaysSinceLastComplete,
      };

  factory Habit.fromMap(Map<String, dynamic> map) => new Habit(
        map[DBProvider.COLUMN_TASK],
        id: map[DBProvider.COLUMN_ID],
        complete: map[DBProvider.COLUMN_COMPLETE] == 1,
        currentStreak: map[DBProvider.COLUMN_CURRENTSTREAK],
        longestStreak: map[DBProvider.COLUMN_LONGESTSTREAK],
        daysSinceLastComplete: map[DBProvider.COLUMN_DAYSSINCELASTCOMPLETE],
        prevDaysSinceLastComplete:
            map[DBProvider.COLUMN_PREVDAYSSINCELASTCOMPLETE],
      );

  @override
  toString() {
    return 'Habit { task: $task, complete: $complete, daysSinceLastComplete: $daysSinceLastComplete }';
  }

  @override
  List<Object> get props => [
        id,
        task,
        complete,
        currentStreak,
        longestStreak,
        daysSinceLastComplete,
        prevDaysSinceLastComplete
      ];
}
