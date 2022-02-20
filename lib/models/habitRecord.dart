import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:twoday/services/Database.dart';

class HabitEntry {
  final String id;
  final String habitId;
  final DateTime date;

  HabitEntry({@required this.habitId, @required this.date, String id})
      : this.id = id ?? UniqueKey().toString();

  factory HabitEntry.fromMap(Map<String, dynamic> map) => HabitEntry(
        id: map[DBProvider.HABITRECORDS_COLUMN_ID],
        habitId: map[DBProvider.HABITRECORDS_COLUMN_HABIT_ID],
        date: DateTime.parse(map[DBProvider.HABITRECORDS_COLUMN_DATE]),
      );

  Map<String, dynamic> toMap() => {
        DBProvider.HABITRECORDS_COLUMN_ID: id,
        DBProvider.HABITRECORDS_COLUMN_HABIT_ID: habitId,
        DBProvider.HABITRECORDS_COLUMN_DATE:
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };

  @override
  toString() => 'HabitRecord { id: $id, habit: $habitId, date: $date }';
}
