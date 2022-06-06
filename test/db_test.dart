import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twoday/models/habitEntry.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/services/database.dart';
import 'package:twoday/services/db_constants.dart';

void main() {
  group("Mock DBProvider", () {
    final provider = MockDBProvider();
    Habit habit;

    setUp(() async {
      habit = Habit("Habit 1");
      await provider.initDB();
      await provider.createHabit(habit);
    });

    tearDown(() async {
      await provider.db.close();
    });

    test("Test initialization of database", () async {
      await provider.db.close();
      expect(provider.db.isOpen, false);
      await provider.initDB();
      expect(provider.db.isOpen, true);
    });

    test("Expect 1 habits when fetching all existing habits", () async {
      final habits = await provider.getAllHabitsWithoutData();
      expect(habits.length, 1);
    });

    test("Create habit", () async {
      var res = await provider.createHabit(Habit("Test habit"));
      expect(res > 0, true);
      final habits = await provider.getAllHabitsWithoutData();
      expect(habits.length, 2);
    });
    test("Delete habit", () async {
      final habits = await provider.getAllHabitsWithoutData();
      final res = await provider.deleteHabitById(habits[0].id);
      expect(res, 1);
    });
    test("Update habit", () async {
      var res = await provider.updateHabit(habit.copyWith(task: "Habit 2"));
      expect(res, 1);

      var habits = await provider.getAllHabitsWithoutData();
      expect(habits[0].task, "Habit 2");
    });
    test("Insert habit entry", () async {
      final dateTime = DateTime(2022, 2, 25);
      var res = await provider.insertHabitEntry(habit.id, dateTime);
      expect(res, 1);

      var habitEntriesOfHabit =
          await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 1);
    });
    test("Delete habit entry", () async {
      final dateTime = DateTime(2022, 2, 25);
      var res = await provider.insertHabitEntry(habit.id, dateTime);
      expect(res, 1);

      res = await provider.deleteHabitEntry(habit.id, dateTime);
      expect(res, 1);

      var habitEntriesOfHabit =
          await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 0);
    });

    test("Get all habit entries of habit", () async {
      final dateTime1 = DateTime(2022, 2, 25);
      final dateTime2 = DateTime(2022, 3, 25);
      final dateTime3 = DateTime(2022, 4, 25);

      var habitEntriesOfHabit =
          await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 0);

      await provider.insertHabitEntry(habit.id, dateTime1);
      habitEntriesOfHabit = await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 1);

      await provider.insertHabitEntry(habit.id, dateTime2);
      habitEntriesOfHabit = await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 2);

      await provider.insertHabitEntry(habit.id, dateTime3);
      habitEntriesOfHabit = await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 3);
    });
    test("Delete all habit entries of habit", () async {
      final dateTime1 = DateTime(2022, 2, 25);
      final dateTime2 = DateTime(2022, 3, 25);
      final dateTime3 = DateTime(2022, 4, 25);

      await provider.insertHabitEntry(habit.id, dateTime1);
      await provider.insertHabitEntry(habit.id, dateTime2);
      await provider.insertHabitEntry(habit.id, dateTime3);

      var habitEntriesOfHabit =
          await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 3);

      var res = await provider.deleteAllHabitEntriesOfHabit(habit.id);
      expect(res > 0, true);

      habitEntriesOfHabit = await provider.getAllHabitEntriesOfHabit(habit.id);
      expect(habitEntriesOfHabit.length, 0);
    });
  });
}

class MockDBProvider implements DBProvider {
  Database _db;
  Database get db => _db;

  @override
  Future<Database> get database async {
    if (db != null) return db;
    await initDB();
    return db;
  }

  @override
  initDB() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
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
      },
    );
  }

  @override
  Future<List<Habit>> getAllHabitsWithoutData() async {
    final db = await database;
    final habitResults = await db.rawQuery("SELECT * FROM $TABLE_HABIT");
    List<Habit> habits = <Habit>[];

    for (final habitResult in habitResults) {
      habits.add(Habit.fromMap(habitResult));
    }

    return habits;
  }

  @override
  Future<int> createHabit(Habit habit) async {
    final db = await database;
    var res = await db.insert(TABLE_HABIT, habit.toMap());
    return res;
  }

  @override
  Future<int> deleteHabitById(String id) async {
    final db = await database;
    var res = await db.delete(TABLE_HABIT, where: "id = ?", whereArgs: [id]);
    return res;
  }

  @override
  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    var res = await db.update(TABLE_HABIT, habit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
    return res;
  }

  @override
  Future<int> insertHabitEntry(String habitId, DateTime dateTime) async {
    final db = await database;
    var actionDateTime =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(dateTime));

    var habitEntry = HabitEntry(habitId: habitId, date: actionDateTime);
    var res = await db.insert(TABLE_HABITRECORDS, habitEntry.toMap());
    return res;
  }

  @override
  Future<int> deleteHabitEntry(String habitId, DateTime dateTime) async {
    final db = await database;
    String dateTimeToString =
        "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

    var res = await db.rawDelete('''DELETE FROM $TABLE_HABITRECORDS
        WHERE $HABITRECORDS_COLUMN_HABIT_ID = ?
        AND $HABITRECORDS_COLUMN_DATE = ?''', [habitId, dateTimeToString]);
    return res;
  }

  @override
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

  @override
  Future<int> deleteAllHabitEntriesOfHabit(String habitId) async {
    final db = await database;
    var res = await db.delete(TABLE_HABITRECORDS,
        where: "$HABITRECORDS_COLUMN_HABIT_ID = ?", whereArgs: [habitId]);
    return res;
  }
}
