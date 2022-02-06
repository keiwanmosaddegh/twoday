import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:twoday/models/habitRecord.dart';
import 'package:twoday/models/habit.dart';

class DBProvider {
  static final _dbName = 'habitDB.db';
  static final _dbVersion = 1;

  static const String TABLE_HABIT = "habit";
  static const String HABIT_COLUMN_ID = "id";
  static const String HABIT_COLUMN_TASK = "task";
  static const String HABIT_COLUMN_DONE = "done";
  static const String HABIT_COLUMN_CURRENT_STREAK = "current_streak";
  static const String HABIT_COLUMN_LONGEST_STREAK = "longest_streak";
  static const String HABIT_COLUMN_DAYS_SINCE_LAST_DONE =
      "days_since_last_done";

  static const String TABLE_HABITRECORDS = "habit_records";
  static const String HABITRECORDS_COLUMN_ID = "id";
  static const String HABITRECORDS_COLUMN_HABIT_ID = "habit_id";
  static const String HABITRECORDS_COLUMN_DATE = "date";

  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
            CREATE TABLE $TABLE_HABIT(
            $HABIT_COLUMN_ID TEXT PRIMARY KEY,
            $HABIT_COLUMN_TASK TEXT        
            )
            ''');
      await db.execute('''
            CREATE TABLE $TABLE_HABITRECORDS(
            $HABITRECORDS_COLUMN_ID TEXT PRIMARY KEY,
            $HABITRECORDS_COLUMN_HABIT_ID TEXT,
            $HABITRECORDS_COLUMN_DATE TEXT     
            )
            ''');
    });
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final habitResults = await db.rawQuery("SELECT * FROM $TABLE_HABIT");
    List<Habit> habitList = <Habit>[];

    for (final habitResult in habitResults) {
      final habitMetrics = await getHabitMetrics(habitResult["id"]);
      final enrichedHabit = {...habitResult, ...habitMetrics};
      final habit = Habit.fromMap(enrichedHabit);
      print("habit: $habit");
      habitList.add(habit);
    }
    return habitList;
  }

  Future<int> createHabit(Habit habit) async {
    final db = await database;
    var res = await db.insert(TABLE_HABIT, habit.toMap());
    return res;
  }

  Future<int> deleteHabit(String id) async {
    final db = await database;
    var res1 = await db.delete(TABLE_HABIT, where: "id = ?", whereArgs: [id]);
    var res2 = await db.delete(TABLE_HABITRECORDS,
        where: "$HABITRECORDS_COLUMN_HABIT_ID = ?", whereArgs: [id]);
    return res1 + res2;
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    var res = await db.update(TABLE_HABIT, habit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
    return res;
  }

  Future<int> toggleHabitEntry(
    String habitId,
    bool value,
    DateTime dateTime,
  ) async {
    final db = await database;
    var actionDateTime =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(dateTime));
    String dateTimeToString =
        "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    var habitRecordEntry = HabitRecord(habitId: habitId, date: actionDateTime);

    if (value) {
      var res = await db.insert(TABLE_HABITRECORDS, habitRecordEntry.toMap());
      return res;
    }

    var res = await db.rawDelete('''DELETE FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        AND $HABITRECORDS_COLUMN_DATE = ?''', [habitId, dateTimeToString]);

    return res;
  }

  Future<List<HabitRecord>> getHabitEntries(String id) async {
    final db = await database;
    var res = await db.rawQuery('''SELECT * FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        ORDER BY $HABITRECORDS_COLUMN_DATE DESC''', [id]);

    List<HabitRecord> habitRecords = <HabitRecord>[];
    for (final record in res) {
      habitRecords.add(HabitRecord.fromMap(record));
    }

    return habitRecords;
  }

  Future<Map<String, dynamic>> getHabitMetrics(String habitId) async {
    final habitRecords = await getHabitEntries(habitId);
    var currentStreak = 0;
    var longestStreak = 0;
    var done = 0;
    var daysSinceMostRecentHabitEntry = 4;

    if (habitRecords.isNotEmpty) {
      var currentDateTime =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

      HabitRecord mostRecentHabitEntry;
      for (var i = 0; i < habitRecords.length; i) {
        if (habitRecords[0].date.difference(currentDateTime).inDays <= 0) {
          mostRecentHabitEntry = habitRecords[0];
          break;
        }
        habitRecords.removeAt(0);
      }

      if (mostRecentHabitEntry != null) {
        daysSinceMostRecentHabitEntry =
            currentDateTime.difference(mostRecentHabitEntry.date).inDays;

        var isStreakActive = daysSinceMostRecentHabitEntry < 3;

        if (daysSinceMostRecentHabitEntry == 0) {
          done = 1;
        }

        if (isStreakActive) {
          var iterationDate = habitRecords[0].date;
          for (var i = 0; i < habitRecords.length; i) {
            if (iterationDate.difference(habitRecords[0].date).inDays < 3) {
              currentStreak++;
              iterationDate = habitRecords[0].date;
              habitRecords.removeAt(0);
            } else {
              break;
            }
          }
          longestStreak = currentStreak;
        }
      }

      if (habitRecords.isNotEmpty) {
        var tempStreak = 0;
        var iterationDate = habitRecords[0].date;
        for (var i = 0; i < habitRecords.length; i) {
          if (iterationDate.difference(habitRecords[0].date).inDays < 3) {
            tempStreak++;
            iterationDate = habitRecords[0].date;
            habitRecords.removeAt(0);
          } else {
            if (tempStreak > longestStreak) {
              longestStreak = tempStreak;
            }
            tempStreak = 0;
            iterationDate = habitRecords[0].date;
          }
        }

        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      }
    }

    return {
      HABIT_COLUMN_DONE: done,
      HABIT_COLUMN_CURRENT_STREAK: currentStreak,
      HABIT_COLUMN_LONGEST_STREAK: longestStreak,
      HABIT_COLUMN_DAYS_SINCE_LAST_DONE: daysSinceMostRecentHabitEntry
    };
  }

  Future<Map<String, dynamic>> getHabitDetails(
      {String habitId, int year}) async {
    final habitRecords = await getHabitEntries(habitId);
    var q1Count = 0;
    var q2Count = 0;
    var q3Count = 0;
    var q4Count = 0;
    List<DateTime> recordsForYear = [];
    var currentDateTime =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    for (final record in habitRecords) {
      if (record.date.year == year) {
        recordsForYear.add(record.date);
        if (record.date.difference(currentDateTime).inDays <= 0) {
          if (record.date.month <= 3) {
            q1Count++;
          } else if (record.date.month >= 4 && record.date.month <= 6) {
            q2Count++;
          } else if (record.date.month >= 7 && record.date.month <= 9) {
            q3Count++;
          } else if (record.date.month >= 10 && record.date.month <= 12) {
            q4Count++;
          }
        }
      }
    }

    return {
      "year": year,
      "quarterStatistics": {
        "q1Count": q1Count,
        "q2Count": q2Count,
        "q3Count": q3Count,
        "q4Count": q4Count
      },
      "recordsForYear": recordsForYear
    };
  }
}
