import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:twoday/models/habitEntry.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/services/db_constants.dart';

class DBProvider {
  static final _dbName = 'habitDB.db';
  static final _dbVersion = 1;

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

  Future<List<Habit>> getAllHabitsWithoutData() async {
    final db = await database;
    final habitResults = await db.rawQuery("SELECT * FROM $TABLE_HABIT");
    List<Habit> habits = <Habit>[];

    for (final habitResult in habitResults) {
      habits.add(Habit.fromMap(habitResult));
    }

    return habits;
  }

  Future<int> createHabit(Habit habit) async {
    final db = await database;
    var res = await db.insert(TABLE_HABIT, habit.toMap());
    return res;
  }

  Future<int> deleteHabitById(String id) async {
    final db = await database;
    var res = await db.delete(TABLE_HABIT, where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    var res = await db.update(TABLE_HABIT, habit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
    return res;
  }

  Future<int> insertHabitEntry(
    String habitId,
    DateTime dateTime,
  ) async {
    final db = await database;
    var actionDateTime =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(dateTime));

    var habitEntry = HabitEntry(habitId: habitId, date: actionDateTime);
    var res = await db.insert(TABLE_HABITRECORDS, habitEntry.toMap());
    return res;
  }

  Future<int> deleteHabitEntry(
    String habitId,
    DateTime dateTime,
  ) async {
    final db = await database;
    String dateTimeToString =
        "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

    var res = await db.rawDelete('''DELETE FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        AND $HABITRECORDS_COLUMN_DATE = ?''', [habitId, dateTimeToString]);
    return res;
  }

  Future<List<HabitEntry>> getAllHabitEntriesOfHabit(String habitId) async {
    final db = await database;
    var entries = await db.rawQuery('''SELECT * FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        ORDER BY $HABITRECORDS_COLUMN_DATE DESC''', [habitId]);

    List<HabitEntry> habitEntries = <HabitEntry>[];
    for (final entry in entries) {
      habitEntries.add(HabitEntry.fromMap(entry));
    }

    return habitEntries;
  }

  Future<int> deleteAllHabitEntriesOfHabit(String habitId) async {
    final db = await database;
    var res = await db.delete(TABLE_HABITRECORDS,
        where: "$HABITRECORDS_COLUMN_HABIT_ID = ?", whereArgs: [habitId]);
    return res;
  }
}
