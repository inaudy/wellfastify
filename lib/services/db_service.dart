import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wellfastify/models/fasting_model.dart';
import 'package:wellfastify/models/timer_model.dart';
import 'package:wellfastify/models/weight_model.dart';
import 'dart:math';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  static Database? _database;
  DBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fasting_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fasting (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT,
        endTime TEXT,
        fastingHours INTEGER,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE weight (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        weight REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE timer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT,
        duration INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE weightgoal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal REAL        
      )
    ''');
    // create a row after create the table
    await db.insert('weightgoal', {'goal': 0.0});
    //await _insertInitialFastingData(db);
  }

//mock data to test
  Future<void> insertRandomFastingData() async {
    final db = await database;
    final random = Random();

    for (int i = 3; i < 10; i++) {
      // Generate fasting data for the last 7 days
      DateTime date = DateTime.now().subtract(Duration(days: i));
      DateTime startTime = DateTime(date.year, date.month, date.day, 19,
          random.nextInt(60)); // Approx 19:00
      DateTime endTime = startTime.add(Duration(
          hours: 16,
          minutes: 30 + random.nextInt(60))); // Approx 11:30 next day

      Fasting fasting = Fasting(
        startTime: startTime,
        endTime: endTime,
        fastingHours: endTime.difference(startTime).inHours * 60 * 60,
        date: DateTime(date.year, date.month, date.day),
      );

      await db.insert('fasting', fasting.toMap());
    }
  }

  // CRUD methods for Fasting
  //Insert Fasting
  Future<int> insertFasting(Fasting fasting) async {
    final db = await database;
    return await db.insert('fasting', fasting.toMap());
  }

  //Get all Fastings
  Future<List<Fasting>> getFastings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fasting');
    return List.generate(maps.length, (i) {
      return Fasting.fromMap(maps[i]);
    });
  }

  //Delete Fasting
  Future<int> deleteFasting(int id) async {
    final db = await database;
    return await db.delete('fasting', where: 'id = ?', whereArgs: [id]);
  }

  //Delete all Fastings
  Future<int> deleteAllFastings() async {
    final db = await database;
    return await db.delete('fasting');
  }

  //Get Total Fasts
  Future<int> getTotalFasts() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM fasting');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    } else {
      return 0;
    }
  }

//Get Total Fasting time
  Future<int> getTotalFastingTime() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(fastingHours) as total FROM fasting');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    } else {
      return 0;
    }
  }

// Longest Fast
  Future<int> getLongestFast() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT MAX(fastingHours) as longest FROM fasting');
    if (result.isNotEmpty && result.first['longest'] != null) {
      return result.first['longest'] as int;
    } else {
      return 0;
    }
  }

  //Get Average Fasts
  Future<int> getAverageFast() async {
    final db = await database;
    int averageInt = 0;
    final result =
        await db.rawQuery('SELECT AVG(fastingHours) as total FROM fasting');

    if (result.isNotEmpty && result.first['total'] != null) {
      averageInt = (result.first['total'] as double).toInt();
      return averageInt;
    } else {
      return averageInt;
    }
  }

  //Get Max Streak Fasts
  Future<int> getMaxStreak() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT date FROM fasting
    ORDER BY date ASC
  ''');
    if (result.isEmpty) {
      return 0;
    }
    int maxStreak = 1;
    int currentStreak = 1;
    DateTime? previousDate = DateTime.parse(result.first['date']);
    for (int i = 1; i < result.length; i++) {
      final DateTime currentDate = DateTime.parse(result[i]['date']);
      if (currentDate.difference(previousDate!).inDays == 1) {
        currentStreak++;
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
      previousDate = currentDate;
    }
    return maxStreak;
  }

  //Get Current Streak
  Future<int> getCurrentStreak() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT date FROM fasting
    ORDER BY date ASC
  ''');
    if (result.isEmpty) {
      return 0; // No data, no streak
    }
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    int currentStreak = 1;
    DateTime? previousDate = DateTime.parse(result.last['date']);
    if (yesterday.difference(previousDate).inDays > 0) {
      return 0;
    }
    for (int i = 1; i < result.length; i++) {
      final DateTime currentDate =
          DateTime.parse(result[result.length - 1 - i]['date']);
      if (previousDate!.difference(currentDate).inDays == 1) {
        currentStreak++;
        previousDate = currentDate;
      } else {
        break;
      }
    }

    return currentStreak;
  }

  // In DBService class
  Future<List<Map<String, dynamic>>> getFastingTimesForLastDays(
      int days) async {
    // Query to get the fasting times for the last 'days' number of days
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT date, SUM(fastingHours) as totalFastingTime
    FROM fasting
    WHERE date >= date('now', '-$days day')
    GROUP BY date
    ORDER BY date ASC;
  ''');
    return results;
  }

  // CRUD methods for Weight
  //Insert Weight
  Future<int> insertWeight(Weight weight) async {
    final db = await database;
    return await db.insert('weight', weight.toMap());
  }

  Future<int> updateWeightGoal(double weight) async {
    final db = await database;
    return await db.update('weightgoal', {'goal': weight}, where: 'id = 1');
  }

  //Get all Weights
  Future<List<Weight>> getWeights() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weight');
    return List.generate(maps.length, (i) {
      return Weight.fromMap(maps[i]);
    });
  }

  Future<double?> getWeightGoal() async {
    final db = await database;
    // Query to get the weight goal
    final List<Map<String, dynamic>> result = await db.query(
      'weightgoal',
      limit: 1, // Ensure we only fetch the first (and only) row
    );
    if (result.isNotEmpty) {
      // If a result exists, return the weight goal
      return result.first['goal'] as double;
    } else {
      return 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> getLastWeights() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
  SELECT * FROM weight ORDER BY date DESC LIMIT 7;
''');
    return results.reversed.toList();
  }

  //Delete Weight
  Future<int> deleteWeight(int id) async {
    final db = await database;
    return await db.delete('weight', where: 'id = ?', whereArgs: [id]);
  }

  //Delete all Weights
  Future<int> deleteAllWeights() async {
    final db = await database;
    return await db.delete('weight');
  }

  // CRUD methods for Timer
  //Insert Timer
  Future<int> insertTimer(TimerData timer) async {
    final db = await database;
    return await db.insert('timer', timer.toMap());
  }

  //Get Timer
  Future<TimerData?> getTimer() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timer', limit: 1);
    if (maps.isNotEmpty) {
      return TimerData.fromMap(maps.first);
    }
    return null;
  }

  //Update Timer
  Future<int> updateTimerData({required int newDuration}) async {
    final db = await database;
    return await db.update(
      'timer',
      {
        'duration': newDuration,
      },
      where: 'id = ?', // Condition to update only the first row
      whereArgs: [1], // ID of the first row
    );
  }

  //Delete Timer
  Future<int> deleteTimerData() async {
    final db = await database;
    return await db.delete('timer');
  }
}
