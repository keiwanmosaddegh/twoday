import 'package:flutter/cupertino.dart';
import 'package:twoday/services/db_constants.dart';

class HabitEntry {
  final String id;
  final String habitId;
  final DateTime date;

  HabitEntry({@required this.habitId, @required this.date, String id})
      : this.id = id ?? UniqueKey().toString();

  factory HabitEntry.fromMap(Map<String, dynamic> map) => HabitEntry(
        id: map[HABITRECORDS_COLUMN_ID],
        habitId: map[HABITRECORDS_COLUMN_HABIT_ID],
        date: DateTime.parse(map[HABITRECORDS_COLUMN_DATE]),
      );

  Map<String, dynamic> toMap() => {
        HABITRECORDS_COLUMN_ID: id,
        HABITRECORDS_COLUMN_HABIT_ID: habitId,
        HABITRECORDS_COLUMN_DATE:
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };

  @override
  toString() => 'HabitRecord { id: $id, habit: $habitId, date: $date }';
}
