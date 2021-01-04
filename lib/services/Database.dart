import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:twodayrule/models/habit.dart';
import 'package:twodayrule/models/lastVisit.dart';

class DBProvider {
  static final _dbName = 'habitDB.db';
  static final _dbVersion = 1;

  static const String TABLE_HABIT = "habit";
  static const String COLUMN_ID = "id";
  static const String COLUMN_TASK = "task";
  static const String COLUMN_COMPLETE = "complete";
  static const String COLUMN_CURRENTSTREAK = "currentStreak";
  static const String COLUMN_LONGESTSTREAK = "longestStreak";
  static const String COLUMN_DAYSSINCELASTCOMPLETE = "daysSinceLastComplete";
  static const String COLUMN_PREVDAYSSINCELASTCOMPLETE = "prevDaysSinceLastComplete";

  static const String TABLE_GENERAL = "general";
  static const String GENERAL_COLUMN_ID = "id";
  static const String GENERAL_COLUMN_LASTVISIT = "lastVisit";

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
            $COLUMN_ID TEXT PRIMARY KEY,
            $COLUMN_TASK TEXT,
            $COLUMN_COMPLETE INTEGER,
            $COLUMN_CURRENTSTREAK INTEGER,
            $COLUMN_LONGESTSTREAK INTEGER,
            $COLUMN_DAYSSINCELASTCOMPLETE INTEGER,
            $COLUMN_PREVDAYSSINCELASTCOMPLETE INTEGER            
            )
            ''');
      await db.execute('''
            CREATE TABLE $TABLE_GENERAL(
            $GENERAL_COLUMN_ID INTEGER PRIMARY KEY,
            $GENERAL_COLUMN_LASTVISIT TEXT     
            )
            ''');
    });
  }

  getAllHabits() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM $TABLE_HABIT");

    List<Habit> habitList = List<Habit>();
    res.forEach((habit) {
       habitList.add(Habit.fromMap(habit));
    });

    return habitList;
  }

  getHabit(Habit habit) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM $TABLE_HABIT WHERE $COLUMN_ID = ?", [habit.id]);
    Habit queriedHabit = Habit.fromMap(res[0]);
    return queriedHabit;
  }

  insertHabit(Habit habit) async {
    final db = await database;
    var res = await db.insert(TABLE_HABIT, habit.toMap());
    return res;
  }

  deleteHabit(String id) async {
    final db = await database;
    db.delete(TABLE_HABIT, where: "id = ?", whereArgs: [id]);
  }

  updateHabit(Habit habit) async {
    final db = await database;
    var res = await db.update(TABLE_HABIT, habit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
    return res;
  }
  
  getLastVisit() async {
    final db = await database;

    var currentDateTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    var newLastVisit = new LastVisit(id: 1, lastVisit: currentDateTime.toString());

    var res = await db.rawQuery("SELECT * FROM $TABLE_GENERAL");

    if(res.isNotEmpty) {
      var prevLastVisit = DateTime.parse(LastVisit.fromMap(res[0]).lastVisit);
      await db.update(TABLE_GENERAL, newLastVisit.toMap());
      return prevLastVisit;
    }

    await db.insert(TABLE_GENERAL, newLastVisit.toMap());
    return currentDateTime;
  }





}
