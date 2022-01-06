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

// QUERY IN USE
  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final habitResults = await db.rawQuery("SELECT * FROM $TABLE_HABIT");
    List<Habit> habitList = <Habit>[];

    for (final habitResult in habitResults) {
      final keyMetrics = await getHabitKeyMetrics(habitResult["id"]);
      final enrichedHabit = {...habitResult, ...keyMetrics};
      final habit = Habit.fromMap(enrichedHabit);
      print("habit: $habit");
      habitList.add(habit);
    }
    return habitList;
  }

  Future<Habit> getHabit(Habit habit) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $TABLE_HABIT WHERE $HABIT_COLUMN_ID = ?", [habit.id]);
    Habit queriedHabit = Habit.fromMap(res[0]);
    return queriedHabit;
  }

// QUERY IN USE
  Future<int> createHabit(Habit habit) async {
    final db = await database;
    var res = await db.insert(TABLE_HABIT, habit.toMap());
    return res;
  }

// QUERY IN USE
  Future<int> deleteHabit(String id) async {
    final db = await database;
    var res = await db.delete(TABLE_HABIT, where: "id = ?", whereArgs: [id]);
    return res;
  }

// QUERY IN USE
  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    var res = await db.update(TABLE_HABIT, habit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
    return res;
  }

// QUERY IN USE
  Future<int> updateHabitRecord(String habitId, bool value) async {
    final db = await database;
    var currentDateTime =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    var habitRecordEntry = HabitRecord(habitId: habitId, date: currentDateTime);

    if (value) {
      var res = await db.insert(TABLE_HABITRECORDS, habitRecordEntry.toMap());
      return res;
    }
    var res = await db.rawDelete('''DELETE FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_ID
        IN ( SELECT $HABITRECORDS_COLUMN_ID
        FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        ORDER BY $HABITRECORDS_COLUMN_DATE DESC LIMIT 1)''', [habitId]);
    return res;
  }

// Query in use
  Future<List<HabitRecord>> getHabitRecords(String id) async {
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

  Future<Map<String, dynamic>> getHabitKeyMetrics(String habitId) async {
    final habitRecords = await getHabitRecords(habitId);
    var currentStreak = 0;
    var longestStreak = 0;
    var done = 0;
    var daysSinceLastDone = 4;

    if (habitRecords.isNotEmpty) {
      var currentDateTime =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      daysSinceLastDone =
          currentDateTime.difference(habitRecords[0].date).inDays;
      var isStreakActive = daysSinceLastDone < 3;

      if (daysSinceLastDone == 0) {
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

    return {
      HABIT_COLUMN_DONE: done,
      HABIT_COLUMN_CURRENT_STREAK: currentStreak,
      HABIT_COLUMN_LONGEST_STREAK: longestStreak,
      HABIT_COLUMN_DAYS_SINCE_LAST_DONE: daysSinceLastDone
    };
  }

  Future<Map<String, int>> getHabitDetails(String habitId) async {
    final habitRecords = await getHabitRecords(habitId);
    var q1Count = 0;
    var q2Count = 0;
    var q3Count = 0;
    var q4Count = 0;

    for (final record in habitRecords) {
      if (record.date.year == DateTime.now().year) {
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

    return {
      "q1Count": q1Count,
      "q2Count": q2Count,
      "q3Count": q3Count,
      "q4Count": q4Count
    };
  }
}
